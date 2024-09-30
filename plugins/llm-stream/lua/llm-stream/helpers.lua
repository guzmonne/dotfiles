-- ╭──────────────────────────────────────╮
-- │ Generic independent helper functions │
-- ╰──────────────────────────────────────╯

local logger = require("llm-stream.logger")

local M = {}

---Feed keys to neovim
---@param keys string String of keystrokes
---@param mode string String of vim mode ('n', 'i', 'c', etc.), default is 'n'
M.feedkeys = function(keys, mode)
	mode = mode or "n"
	keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(keys, mode, true)
end

---Set keymap for specified mode
---@param buffers table Table of buffers
---@param mode table | string Mode(s) to set keymap for
---@param key string Shortcut key
---@param callback function | string Callback or string to set keymap
---@param desc string | nil Optional description for keymap
M.set_keymap = function(buffers, mode, key, callback, desc)
	logger.debug(
		"registering shortcut:"
			.. " mode: "
			.. vim.inspect(mode)
			.. " key: "
			.. key
			.. " buffers: "
			.. vim.inspect(buffers)
			.. " callback: "
			.. vim.inspect(callback)
	)
	for _, buf in ipairs(buffers) do
		vim.keymap.set(mode, key, callback, {
			noremap = true,
			silent = true,
			nowait = true,
			buffer = buf,
			desc = desc,
		})
	end
end

---Creates a new autocommand
---@param events string | table Events to listen to
---@param buffers table | nil Buffers to listen to (nil for all buffers)
---@param callback function Callback to call
---@param gid number Augroup id
M.autocmd = function(events, buffers, callback, gid)
	if buffers then
		for _, buf in ipairs(buffers) do
			vim.api.nvim_create_autocmd(events, {
				group = gid,
				buffer = buf,
				callback = vim.schedule_wrap(callback),
			})
		end
	else
		vim.api.nvim_create_autocmd(events, {
			group = gid,
			callback = vim.schedule_wrap(callback),
		})
	end
end

---Deletes a neovim buffer.
---@param file_name string Name of the file for which to delete buffers
M.delete_buffer = function(file_name)
	-- iterate over buffer list and close all buffers with the same name
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_name(b) == file_name then
			vim.api.nvim_buf_delete(b, { force = true })
		end
	end
end

---Deletes a file and its associated buffer.
---@param file string | nil Name of the file to delete
M.delete_file = function(file)
	logger.debug("deleting file: " .. vim.inspect(file))
	if file == nil then
		return
	end
	M.delete_buffer(file)
	os.remove(file)
end

---Gets the buffer number for a file.
---@param file_name string Name of the file for which to get buffer
---@return number | nil buffer_number Buffer number
M.get_buffer = function(file_name)
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(b) then
			if M.ends_with(vim.api.nvim_buf_get_name(b), file_name) then
				return b
			end
		end
	end
	return nil
end

---Creates a unique uuid
---@return string uuid UUID
M.uuid = function()
	local random = math.random
	local template = "xxxxxxxx_xxxx_4xxx_yxxx_xxxxxxxxxxxx"
	local result = string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
		return string.format("%x", v)
	end)
	return result
end

---Creates a new augroup
---@param name string Name of the augroup
---@param opts table | nil Options for the augroup
---@return number augroup_id Augroup id
M.create_augroup = function(name, opts)
	return vim.api.nvim_create_augroup(name .. "_" .. M.uuid(), opts or { clear = true })
end

---Gets the last content line of a buffer.
---@param buf number # buffer number
---@return number buffer_line The first line with content of specified buffer
M.last_content_line = function(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	-- go from end and return number of last nonwhitespace line
	local line = vim.api.nvim_buf_line_count(buf)
	while line > 0 do
		local content = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1]
		if content:match("%S") then
			return line
		end
		line = line - 1
	end
	return 0
end

---Gets the filetype of a buffer.
---@param buf number Buffer number
---@return string filetype Filetype of specified buffer
M.get_filetype = function(buf)
	return vim.api.nvim_get_option_value("filetype", { buf = buf })
end

---Moves the cursor to a specified line.
---@param line number Line number
---@param buf number Buffer number
---@param win number | nil Window number
M.cursor_to_line = function(line, buf, win)
	-- Don't manipulate cursor if user is elsewhere
	if buf ~= vim.api.nvim_get_current_buf() then
		return
	end

	-- Check if win is valid
	if not win or not vim.api.nvim_win_is_valid(win) then
		return
	end

	-- Move cursor to the line
	vim.api.nvim_win_set_cursor(win, { line, 0 })
end

---Check if a string starts with another string.
---@param str string String to check
---@param start string String to check for
---@return boolean starts_with Whether the string starts with the other string
M.starts_with = function(str, start)
	return str:sub(1, #start) == start
end

---Check if a string ends with another string.
---@param str string String to check
---@param ending string String to check for
---@return boolean ends_with Whether the string ends with the other string
M.ends_with = function(str, ending)
	return ending == "" or str:sub(-#ending) == ending
end

-- Finds the root directory of the current git repository
---@param path string | nil  Optional path to start searching from
---@return string git_root Path of the git root dir or an empty string if not found
M.find_git_root = function(path)
	logger.debug("finding git root for path: " .. vim.inspect(path))
	local cwd = vim.fn.expand("%:p:h")
	if path then
		cwd = vim.fn.fnamemodify(path, ":p:h")
	end

	for _ = 0, 1000 do
		local files = vim.fn.readdir(cwd)
		if vim.tbl_contains(files, ".git") then
			logger.debug("found git root: " .. cwd)
			return cwd
		end
		local parent = vim.fn.fnamemodify(cwd, ":h")
		if parent == cwd then
			break
		end
		cwd = parent
	end
	logger.debug("git root not found")
	return ""
end

---Run undojoin on the provided buffer.
---@param buf number Buffer number
M.undojoin = function(buf)
	if not buf or not vim.api.nvim_buf_is_loaded(buf) then
		return
	end
	local status, result = pcall(vim.cmd.undojoin)
	if not status then
		if result:match("E790") then
			return
		end
		logger.error("Error running undojoin: " .. vim.inspect(result))
	end
end

---Serializes a table to a file.
---@param tbl table The table to be stored
---@param file_path string The file path where the table will be stored as json
M.table_to_file = function(tbl, file_path)
	local json = vim.json.encode(tbl)

	local file = io.open(file_path, "w")
	if not file then
		logger.warning("Failed to open file for writing: " .. file_path)
		return
	end

	file:write(json)
	file:close()
end

---Deserializes a table from a file.
---@param file_path string The file path from where to read the json into a table
---@return table | nil table Table read from the file, or nil if an error occurred
M.file_to_table = function(file_path)
	local file, err = io.open(file_path, "r")
	if not file then
		logger.warning("Failed to open file for reading: " .. file_path .. "\nError: " .. err)
		return nil
	end
	local content = file:read("*a")
	file:close()

	if content == nil or content == "" then
		logger.warning("Failed to read any content from file: " .. file_path)
		return nil
	end

	local tbl = vim.json.decode(content)
	return tbl
end

---Prepares a directory
---@param dir string Directory to prepare
---@param name string | nil Name of the directory
---@return string resolved_dir Resolved directory path
M.prepare_dir = function(dir, name)
	local odir = dir
	dir = dir:gsub("/$", "")
	name = name and name .. " " or ""
	if vim.fn.isdirectory(dir) == 0 then
		logger.debug("creating " .. name .. "directory: " .. dir)
		vim.fn.mkdir(dir, "p")
	end

	dir = vim.fn.resolve(dir)

	logger.debug("resolved " .. name .. "directory:\n" .. odir .. " -> " .. dir)
	return dir
end

---Creates a user command
---@param cmd_name string Name of the command
---@param cmd_func function Function to be executed when the command is called
---@param completion function | table | nil Optional function returning table for completion
---@param desc string | nil Description of the command
---@return table | nil completion Completion table, completion function result, or nil if an error occurred
M.create_user_command = function(cmd_name, cmd_func, completion, desc)
	logger.debug("creating user command: " .. cmd_name)
	vim.api.nvim_create_user_command(cmd_name, cmd_func, {
		nargs = "*",
		range = true,
		desc = desc or "LlmStream.nvim command",
		complete = function(arg_lead, cmd_line, cursor_pos)
			logger.debug(
				"completing user command: "
					.. cmd_name
					.. "\narg_lead: "
					.. arg_lead
					.. "\ncmd_line: "
					.. cmd_line
					.. "\ncursor_pos: "
					.. cursor_pos
			)
			if not completion then
				return {}
			end
			if type(completion) == "function" then
				return completion(arg_lead, cmd_line, cursor_pos) or {}
			end
			if type(completion) == "table" then
				return completion
			end
			return {}
		end,
	})
end

return M
