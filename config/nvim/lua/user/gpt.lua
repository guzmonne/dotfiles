local M = {}

local functions = require('user.functions')

local options = {
    debug = false,
    previous_lines = 3,
    max_tokens = 100,
}


local CONTINUE_SYSTEM_PROMPT = [[
You are a ghostwriter, responsible for collaborating with other authors to extend their works. You will be given the context of the text that precedes the point where you need to continue, and you will deliver text that seamlessly continues the narrative.

Your task involves ensuring that the intended narrative flow is flawlessly preserved; this requires not only comprehension but also imagination and a sense of narrative continuity. Grasp the tone of the original text and ensure it is sustained throughout your extension. Pay close attention to character voice, narrative voice, and the overall style, and incorporate them into the text you are writing.

Also, do not hesitate to introduce new, engaging elements or deepen existing ones within the context of the narrative, as long as they blend smoothly with the overall storyline and complements its development. Use captivating metaphors, and enrich/brighten the expression without deviating from its original voice.

Try to use simple language on your writing, that match the tone of the original text. Don't overuse big words, and try to keep sentences short and to the point.
]]

--- Edits the current line and replaces it with an edited version of it.
function M.edit()
    -- Get the current line content
    local prompt = vim.api.nvim_get_current_line()

    if options.debug then
        print("Prompt: " .. prompt)
    end

    local output = vim.fn.system({ "c", "o", "--session", "olit", "--max-tokens", options.max_tokens, prompt })

    -- Trim the output newline
    output = output:sub(1, -2)

    -- Print the type of the output for debugging.
    if options.debug then
        print("Output: " .. output)
    end

    -- Replace the contents of the current line with the output
    vim.api.nvim_set_current_line(output)
end

--- Tries to continue the text by taking the last `max_previous_characters` words, and the next `max_next_words` words using GPT-4 or claude.
function M.continue()
    -- Get the current line and column number
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local text = vim.api.nvim_get_current_line()

    -- Get the characters before and after the cursor
    local before = text:sub(1, col)

    -- Get the last options.previous_lines lines from the current line
    local previous_lines = vim.api.nvim_buf_get_lines(0, line - options.previous_lines, line, false)

    -- Create a prompt with the previous lines, the current line, and the next lines and the '<|continue|>' placeholder
    local prompt = table.concat(previous_lines, "\n") .. "\n" .. before

    if options.debug then
        print("Prompt: " .. prompt)
    end

    local output = vim.fn.system({ "c", "o", "--model", "gpt4", "--max-tokens", options.max_tokens,
        "--system",
        CONTINUE_SYSTEM_PROMPT,
        prompt })

    -- Trim the output newline
    output = output:sub(1, -2)

    -- Print the type of the output for debugging.
    if options.debug then
        print("Output: " .. output)
    end

    -- Split the output by newline characters
    local lines = functions.split_newline(output)

    if #lines == 1 then
        lines[1] = before .. lines[1]
        vim.api.nvim_buf_set_lines(0, line - 1, line, false, { lines[1] })
    else
        lines[1] = before .. lines[1]
        -- Get all the lines on the buffer
        local buffer = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        -- Add the lines from the current cursor position
        vim.api.nvim_buf_set_lines(0, line - 1, line + #lines - 1, false, lines)
        -- Add the remaining buffer lines
        vim.api.nvim_buf_set_lines(0, line + #lines, #buffer + #lines - 2, false,
            functions.slice_table(buffer, line + 1, #buffer))
    end

    if options.debug then
        print("Lines: " .. vim.inspect(lines))
    end
end

--- Sets up the plugin.
function M.setup(opts)
    -- Merge opts with the default options
    options = vim.tbl_extend('force', options, opts or {})
end

-- Setup custom options
M.setup({
    debug = false,
    previous_lines = 3,
    max_tokens = 256,
})

---
return M
