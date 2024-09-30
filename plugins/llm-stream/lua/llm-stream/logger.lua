-- ╭───────────────╮
-- │ Logger Module │
-- ╰───────────────╯

local uv = vim.uv or vim.loop

local M = {}

local file = "/dev/null"
local uuid = ""

M._log_history = {}

---Returns the current timestamps with milliseconds accuracy
---@return string
M.now = function()
	local time = os.date("%Y-%m-%d.%H-%M-%S")
	local stamp = tostring(math.floor(uv.hrtime() / 1000000) % 1000)
	-- make sure stamp is 3 digits
	while #stamp < 3 do
		stamp = stamp .. "0"
	end
	return time .. "." .. stamp
end

---Setups a logger instance
---@param path string The path to the log file
M.setup = function(path)
	uuid = string.format("%x", math.random(0, 0xFFFF)) .. string.format("%x", os.time() % 0xFFFF)
	M.debug("New neovim instance [" .. uuid .. "] started, setting log file to " .. path)
	local dir = vim.fn.fnamemodify(path, ":h")
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
	file = path

	-- truncate log file if it's too big
	if uv.fs_stat(file) then
		local content = {}
		for line in io.lines(file) do
			table.insert(content, line)
		end

		if #content > 20000 then
			local truncated_file = io.open(file, "w")
			if truncated_file then
				for i, line in ipairs(content) do
					if #content - i < 10000 then
						truncated_file:write(line .. "\n")
					end
				end
				truncated_file:close()
				M.debug("Log file " .. file .. " truncated to last 10K lines")
			end
		end
	end

	local log_file = io.open(file, "a")
	if log_file then
		for _, line in ipairs(M._log_history) do
			log_file:write(line .. "\n")
		end
		log_file:close()
	end
end

---Logs a message with a custom level
---@param msg string The message to log
---@param level number The level of the log
---@param slevel string The string level of the log
local log = function(msg, level, slevel)
	local raw = msg
	raw = string.format("[%s] [%s] %s: %s", M.now(), uuid, slevel, raw)

	M._log_history[#M._log_history + 1] = raw

	if #M._log_history > 20 then
		table.remove(M._log_history, 1)
	end

	local log_file = io.open(file, "a")
	if log_file then
		log_file:write(raw .. "\n")
		log_file:close()
	end

	if level <= vim.log.levels.DEBUG then
		return
	end

	vim.schedule(function()
		vim.notify("Gp.nvim: " .. msg, level, { title = "Gp.nvim" })
	end)
end

---Logs a message with error level
---@param msg string The message to log
M.error = function(msg)
	log(msg, vim.log.levels.ERROR, "ERROR")
end

---Logs a message with warning level
---@param msg string The message to log
M.warn = function(msg)
	log(msg, vim.log.levels.WARN, "WARN")
end

---Logs a message with info level
---@param msg string The message to log
M.info = function(msg)
	log(msg, vim.log.levels.INFO, "INFO")
end

---Logs a message with debug level
---@param msg string The message to log
M.debug = function(msg)
	log(msg, vim.log.levels.DEBUG, "DEBUG")
end

return M
