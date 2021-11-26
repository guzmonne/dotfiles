local Input = require'nui.input'
local event = require'nui.utils.autocmd'.event

local function nui_lsp_rename()
  local curr_name = vim.fn.expand("<cword>")
  local params = vim.lsp.util.make_position_params()

  local function on_submit(new_name)
    if not new_name or #new_name == 0 or curr_name == new_name then
      -- do nothing.
      return
    end

    -- Add `newName` property to `params`.
    -- This is necessary for maiking `textDocument/rename` requests.
    params.newName = new_name


    -- Send the `textDocument/rename` request to the LSP server.
    vim.lsp.buf_request(0, "textDocument/rename", params, function (_, result, _, _)
      if not result then
        -- do nothing.
        return
      end

      -- The `result` contains all the places we need to update
      -- the name of the identifier. So we apply those edits.
      vim.lsp.util.apply_workspace_edit(result)

      -- After the edits are applied, the files are not saved automatically.
      -- We need to add a reminder to do so.
      local total_files = vim.tbl_count(result.changes)
      print(
        string.format(
          "Changed %s file%s. To save them run ':wa'",
          total_files,
          total_files > 1 and "s" or ""
        )
      )
    end)
  end

  local popup_options = {
    -- Borders for the window.
    border = {
      style = "rounded",
      text = {
        top = "[Rename]",
        top_align = "left",
      },
    },
    -- Highlight for the window.
    highlight = "Normal:Normal",
    -- Place the popup windoe relative to the buffer
    -- position of the identifier.
    relative = {
      type = "buf",
      position = {
        -- This is the same `params` we got earlier.
        row = params.position.line,
        col = params.position.character,
      },
    },
    -- Position the popup window on the line below the identifier.
    position = {
      row = 1,
      col = 1,
    },
    -- 25 cells wide.
    size = {
      width = math.max(#curr_name + 10, 25),
      height = 1,
    },
  }

  local input = Input(popup_options, {
    -- Set the default value to the current name.
    default_value = curr_name,
    -- Pass the `on_submit` callback.
    on_submit = on_submit,
    prompt = "",
  })

  input:mount()

  -- Close on <ESC> in normal mode.
  input:map("n", "<ESC>", input.input_props.on_close, { noremap = true})

  -- Close when cursor leaves the buffer.
  input:on(event.BufLeave, input.input_props.on_close, { once = true})
end

return {
  lsp_rename = nui_lsp_rename,
}
