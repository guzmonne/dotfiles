-- ls -alh
-- Globals
local uv = vim.uv

-- Description: Tmux REPL
local M = {
	opts = {
		-- Time to wait after splitting a window.
		wait_after_split = 1000,
		-- Time to wait between send_keys
		wait_after_send_keys = 1000,
		-- Tmux `split-pane` options.
		tmux_split_options = "-h",
		-- Prompt before next command
		prompt = true,
		-- Silent mode
		silent = true,
	},
}

local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

--- Returns the current tmux window index.
--- @return string
function M.current_window()
	local handle = io.popen("tmux display-message -p '#I'")

	if not handle then
		vim.notify("Failed to get the current window", vim.log.levels.ERROR, { title = "TmuxRepl" })
		return ""
	end

	for line in handle:lines() do
		-- Trim line
		return trim(line)
	end

	return ""
end

--- Returns the current tmux session name.
--- @return string
function M.current_session()
	local handle = io.popen("tmux display-message -p '#S'")

	if not handle then
		vim.notify("Failed to get the current session", vim.log.levels.ERROR, { title = "TmuxRepl" })
		return ""
	end

	for line in handle:lines() do
		-- Trim line
		return trim(line)
	end

	return ""
end

--- Splits a pane if there is currently only one pane open. Returns the next pane index.
--- @returns number.
function M.split_pane()
	local pane = nil

	local panes = M.panes()

	-- If no panes return.
	if #panes == 0 then
		vim.notify("No tmux panes found", vim.log.levels.ERROR, { title = "TmuxRepl" })
		return
	end

	if #panes == 1 then
		local handle = io.popen(
			"tmux split-window "
				.. M.opts.tmux_split_options
				.. " -t "
				.. M.current_session()
				.. ":"
				.. M.current_window()
		)

		if not handle then
			vim.notify("Failed to open tmux list-panes", vim.log.levels.ERROR, { title = "TmuxRepl" })
			return
		end

		uv.sleep(M.opts.wait_after_split)

		panes = M.panes()
	end

	pane = panes[2].index

	return pane
end

--- Runs a command on a given Tmux pane in the current session and window.
--- @param pane number The index of the pane to run the command on.A
--- @param line string The command to run.
--- @return nil
function M.send_keys(pane, line)
	local cmd = "tmux send-keys -t "
		.. M.current_session()
		.. ":"
		.. M.current_window()
		.. "."
		.. pane
		.. " '"
		.. line
		.. "' C-m"

	local handle = io.popen(cmd)
	if not handle then
		vim.notify("Failed to send command to tmux", vim.log.levels.ERROR, { title = "TmuxRepl" })
		return
	end

	uv.sleep(M.opts.wait_after_send_keys)
end

--- Runs the current line, or the selected commented lines.
--- @param opts table
--- @property opts.count number
--- @property opts.line1 number
--- @property opts.line2 number
--- @return nil
function M.comment_run(opts)
	local pane = M.split_pane()
	if pane == nil then
		vim.notify("No tmux panes found", vim.log.levels.ERROR, { title = "TmuxRepl" })
		return
	end

	local start_line = vim.api.nvim_win_get_cursor(0)[1]
	local end_line = vim.api.nvim_win_get_cursor(0)[1]

	if opts.count > 0 then
		start_line = opts.line1
		end_line = opts.line2
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	for i, line in ipairs(lines) do
		line = trim(line)
		if line ~= "" then
			line = line:match("^%s*%S+%s*(.*)$")
			M.send_keys(pane, line)

			if M.opts.prompt and i < #lines then
				if opts.silent == false then
					vim.notify("Continue with next command? (Y/n): ", vim.log.levels.INFO, { title = "TmuxRepl" })
				end
				local answer = vim.fn.input("Continue with next command? (Y/n): ")
				answer = answer:lower()
				if answer ~= "" and answer ~= "y" then
					break
				end
			end
		end
	end

	if opts.silent == false then
		vim.notify("Done!", vim.log.levels.INFO, { title = "TmuxRepl" })
	end
end

--- Runs the current line, or the selected lines.
--- @param opts table
--- @property opts.count number
--- @property opts.line1 number
--- @property opts.line2 number
--- @return nil
function M.run(opts)
	local pane = M.split_pane()
	if pane == nil then
		vim.notify("No tmux panes found", vim.log.levels.ERROR, { title = "TmuxRepl" })
		return
	end

	local start_line = vim.api.nvim_win_get_cursor(0)[1]
	local end_line = vim.api.nvim_win_get_cursor(0)[1]

	if opts.count > 0 then
		start_line = opts.line1
		end_line = opts.line2
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	for i, line in ipairs(lines) do
		line = trim(line)
		if line ~= "" then
			M.send_keys(pane, line)

			if M.opts.prompt and i < #lines then
				if opts.silent == false then
					vim.notify("Continue with next command? (Y/n): ", vim.log.levels.INFO, { title = "TmuxRepl" })
				end
				local answer = vim.fn.input("Continue with next command? (Y/n): ")
				answer = answer:lower()
				if answer ~= "" and answer ~= "y" then
					break
				end
			end
		end
	end

	if opts.silent == false then
		vim.notify("Done!", vim.log.levels.INFO, { title = "TmuxRepl" })
	end
end

--- Gets the current tmux panes
---@return table
function M.panes()
	local handle = io.popen("tmux list-panes -t " .. M.current_session() .. ":" .. M.current_window())
	local panes = {}
	if not handle then
		vim.notify("Failed to open tmux list-panes", vim.log.levels.ERROR, { title = "TmuxRepl" })
		return {}
	end

	for line in handle:lines() do
		local index, columns, rows, id = line:match("^(%d+):%s%[(%d+)x(%d+)%].* (%S+)%s*$")
		-- `active` is true if `line` includes the substring `(active)`.
		local active = line:match("%(active%)")

		table.insert(panes, {
			active = active == "(active)",
			columns = tonumber(columns),
			id = id,
			index = tonumber(index),
			rows = tonumber(rows),
		})
	end

	return panes
end

---Plugin setup function
---@param opts table
---@return nil
function M.setup(opts)
	for k, v in pairs(opts) do
		M.opts[k] = v
	end

	vim.api.nvim_create_user_command("TmuxRepl", function(lopts)
		local cmd = lopts.args
		if cmd == "run" then
			M.run(lopts)
		elseif cmd == "comment_run" then
			M.comment_run(lopts)
		elseif cmd == "current_session" then
			vim.print(M.current_session())
		elseif cmd == "current_window" then
			vim.print(M.current_window())
		elseif cmd == "panes" then
			vim.print(M.panes())
		else
			vim.notify("Unknown command: " .. cmd, vim.log.levels.ERROR, { title = "TmuxRepl" })
		end
	end, {
		complete = function()
			return { "run", "panes", "current_session", "current_window" }
		end,
		nargs = 1,
		range = 1,
	})
end

return M
