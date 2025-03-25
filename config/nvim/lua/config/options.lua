-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.list = false
vim.opt.hlsearch = false
vim.opt.scrolloff = 8
vim.opt.swapfile = false
vim.opt.inccommand = "split"

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.python3_host_prog = "/opt/homebrew/opt/python@3.11/libexec/bin/python"
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Other options
vim.opt.title = true

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0
end

local set = vim.opt_local

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    set.number = false
    set.relativenumber = false
    set.scrolloff = 0
  end,
})

-- Easily hit escape in terminal mode
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- Warnings
vim.g.skip_ts_context_commentstring_module = true

-- Search and replace
vim.opt.ignorecase = true -- Search case insensitive.
vim.opt.smartcase = true -- Search matters if capital letter.
vim.opt.inccommand = "split" -- For incsearch while sub.

-- Blink
vim.g.ai_cmp = false

-- Number bar
vim.opt.cursorline = false

-- Enable TOhtml
vim.g.loaded_2html_plugin = nil

-- Fix Markdown files
vim.opt.conceallevel = 0

local cloudbridgeuy = { g = {} }
_G.cloudbridgeuy = cloudbridgeuy

cloudbridgeuy.g.retained = {}

-- Permanently stop `value` from getting garbage-collected.
--
-- @generic T
-- @param value T
-- @return T
local retain = function(value)
  cloudbridgeuy.g.retained[#cloudbridgeuy.g.retained + 1] = value
  return value
end

-- Cache to store per-buffer record of fold markers.
-- Given that we don't expect there to be many markers in any given file, we
-- just store them in a simple list as opposed to a fancier data structure (like
-- a search tree).
local cache = retain({})

-- Don't bother trying to compute marker-based folds for buffers with more than
-- this number of lines.
local max_fold_lines = 10000

local parse_markers = function(lines, start_index)
  local markers = {}
  for i, line in ipairs(lines) do
    local line_number = start_index + i
    local start_level = line:match("{{{(%d+)")
    local end_level = line:match("}}}(%d+)")
    if start_level ~= nil and tonumber(start_level) ~= 0 then
      markers[#markers + 1] = {
        line = line_number,
        level = tonumber(start_level),
        kind = "start",
      }
    elseif end_level ~= nil and tonumber(end_level) ~= 0 then
      markers[#markers + 1] = {
        line = line_number,
        level = tonumber(end_level),
        kind = "end",
      }
    elseif line:match("{{{") then
      markers[#markers + 1] = {
        line = line_number,
        kind = "increase",
      }
    elseif line:match("}}}") then
      markers[#markers + 1] = {
        line = line_number,
        kind = "decrease",
      }
    end
  end
  return markers
end

-- This is a custom foldexpr (see `:help 'foldexpr'`) that combines the best of
-- `:set foldmethod=indent` and `:set foldmethod=marker`:
--
-- - On an indented line, it behaves like `foldmethod=indent`.
-- - On a non-indented line, it behaves like `foldmethod=marker`.
--
-- For the meaning of the return values, see `:help fold-expr`.
--
-- To debug this, set these to show the fold level in the gutter:
--
--    :set statuscolumn=%l\ %{foldlevel(v:lnum)}
--    :set numberwidth=6
--
local foldexpr = function(line_number)
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    -- Believe it or not, we'll get called before the buffer is loaded, and
    -- calling `nvim_buf_attach()` with an unloaded buffer will fail; we have to
    -- bail when this happens.
    return 0
  end
  local line_count = vim.api.nvim_buf_line_count(0)
  if cache[bufnr] == nil then
    if line_count < max_fold_lines then
      -- Populate the cache.
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local markers = parse_markers(lines, 0)
      cache[bufnr] = markers

      -- Subscribe to future updates.
      vim.api.nvim_buf_attach(bufnr, false, {
        on_lines = function(_event, _bufnr, _changed_tick, first_line, last_line, new_last_line)
          local new_lines = vim.api.nvim_buf_get_lines(bufnr, first_line, new_last_line, false)
          local new_markers = parse_markers(new_lines, first_line)
          local old_markers = cache[bufnr]

          if old_markers then
            -- Remove potentially invalid markers inside changed range.
            -- Also, calculate position of marker from which we'll need to adjust
            -- line numbers.
            local position = #old_markers
            if position == 0 then
              -- Beware! If position is 0 (ie. `old_markers` table is empty), then
              -- the `table.move` below will effectively turn it into a non-list
              -- table, breaking it!
              position = 1
            else
              for i = #old_markers, 1, -1 do
                local marker = old_markers[i]
                if marker.line < first_line then
                  break
                elseif marker.line > last_line then
                  position = i
                elseif marker.line >= first_line and marker.line <= last_line then
                  table.remove(old_markers, i)
                  position = position - 1
                end
              end
            end

            -- Add new markers.
            -- Make space by moving elements to the right.
            table.move(old_markers, position, #old_markers, position + #new_markers)
            -- Copy elements from `new_markers` into `old_markers`.
            table.move(new_markers, 1, #new_markers, position, old_markers)

            -- Update line numbers of anything after the inserted/removed markers.
            local delta = new_last_line - last_line
            for i = position + #new_markers, #old_markers, 1 do
              if i ~= 0 then
                old_markers[i].line = old_markers[i].line + delta
              end
            end
          else
            -- Somehow, cache got cleared. Repopulate it.
            cache[bufnr] = new_markers
          end
        end,
        on_detach = function()
          cache[bufnr] = nil
        end,
        on_reload = function()
          cache[bufnr] = nil
        end,
      })
    else
      cache[bufnr] = {}
    end
  end

  -- Look through markers list to figure out the impact on the current line.
  -- If markers are not well-formed, all bets are off.
  local base = 0
  for _, marker in ipairs(cache[bufnr]) do
    if marker.line <= line_number then
      -- Note that when `marker.line == line_number` we don't just return the
      -- level, but rather a level-start indicator (eg. `>1`) instead. This
      -- is so that we can support consecutive markers like in the following
      -- example (where every line is of level 1, but we want 3 folds):
      --
      --     section 1 {{{1
      --     foo
      --     bar
      --     baz
      --
      --     section 2 {{{1
      --     foo
      --     bar
      --     baz
      --
      --     section 3 {{{1
      --     foo
      --     bar
      --     baz
      --
      if marker.kind == "start" then
        if marker.line == line_number then
          return ">" .. marker.level
        end
        base = marker.level
      elseif marker.kind == "end" then
        if marker.line == line_number then
          return "<" .. marker.level
        end
        base = marker.level - 1
      elseif marker.kind == "increase" then
        base = base + 1
        if marker.line == line_number then
          return ">" .. base
        end
      elseif marker.kind == "decrease" then
        base = base - 1
        if marker.line == line_number then
          return ">" .. base
        end
      end
    else
      break
    end
  end

  -- Now we do indent-based folding.
  local line = vim.fn.getline(line_number)
  local current_indent = vim.fn.indent(line_number)
  local previous_non_blank = vim.fn.prevnonblank(line_number - 1)
  local previous_non_blank_indent = vim.fn.indent(previous_non_blank)

  if line == "" then
    -- Blank line.
    return base + math.floor(previous_non_blank_indent / vim.fn.shiftwidth())
  else
    return base + math.floor(current_indent / vim.fn.shiftwidth())
  end
end

local middot = "·"
local raquo = "»"
local small_l = "ℓ"

-- Override default `foldtext()`, which produces something like:
--
--   +---  2 lines: source $HOME/.config/nvim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim--------------------------------
--
-- Instead returning:
--
--   »··[2ℓ]··: source $HOME/.config/nvim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim···································
--
local foldtext = function()
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  local lines = "[" .. line_count .. small_l .. "]"
  local first = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]
  local tabs = first:match("^%s*"):gsub(" +", ""):len()
  local spaces = first:match("^%s*"):gsub("\t", ""):len()
  local indent = spaces + tabs * vim.bo.tabstop
  local stripped = first:match("^%s*(.-)$")
  local prefix = raquo .. middot .. middot .. lines
  local suffix = ": "

  -- Can't usefully use string.len() on UTF-8.
  local prefix_len = tostring(line_count):len() + 6

  local dash_count = math.max(indent - prefix_len - string.len(suffix), 0)
  local dashes = string.rep(middot, dash_count)
  return prefix .. dashes .. suffix .. stripped
end

-- Globally export it.

cloudbridgeuy.foldexpr = foldexpr
cloudbridgeuy.foldtext = foldtext

-- Fold settings
vim.opt.foldlevelstart = 99 -- Start unfolded
vim.opt.foldmethod = "expr"
vim.opt.foldminlines = 0 -- Allow closing even 1-line folds.
vim.opt.foldexpr = "v:lua.cloudbridgeuy.foldexpr(v:lnum)"
vim.opt.foldtext = "v:lua.cloudbridgeuy.foldtext()"

-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldnestmax = 0

-- Copy the current file path to the clipboard
-- Original: monkoose
-- https://www.reddit.com/r/neovim/comments/u221as/comment/i4g4r8b/?utm_source=share&utm_medium=web2x&context=3
vim.api.nvim_create_user_command("Cppath", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
