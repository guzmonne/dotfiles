local M = {}

local functions = require('user.functions')

local options = {
    debug = false,
    max_previous_words = 10,
    max_next_words = 10,
    max_tokens = 100,
}


local CONTINUE_SYSTEM_PROMPT = [[
You are a ghostwriter, in charge of working with other authors extending their writings. You'll be provided with the context of the writing that came before and after the place you have to continue, and you'll return text that fits in between.

You'll be given the piece of text and a placeholder looking like `<|continue|>`. You'll have to write the text that will reoplace it, taking into account the sorrounding text.

Your task is ensuring that the intended narrative flow is perfectly maintained; this demands not just comprehension, but also imaginatio n and a sense of narrative continuity. Get a sense of the tone of the original text, and ensure it persists through your extension. Pay attention to character voice, narrative voice, and the overall style and implement them in the text you are to write.

Moreover, do not forget to examine the content of the 'after' text; use this as your landmark for connection between the preceding narra tive and the consequent content. This way, you'd be able to project the needed trajectory and craft a befitting connection.

Also, do not hesitate to introduce new, engaging elements or deepen existing ones within the context of the narrative, as long as they b lend smoothly with the overall storyline and complements its development. Use captivating metaphors, and enrich/brighten the expression without deviating from its original voice.

This is not to say that you're not allowed to infuse some of your personal touch or explore a bit. Break down the text into relevant seg ments that clearly communicate the necessary information. Feel free to use new paragraphs when moving to a new idea, aspect, event, or v iewpoint. Just remember, your ultimate goal is to fashion a seamless piece that would pass as the work of a single author to an unsuspec ting reader.

Bear these instructions in mind as you delve into the heart of the narrative, embroidering a beautiful bridge between the existing lines . Your pen does not just extend a story; it breathes life into it across the pages.

Please try to continue the text in a way that is consistent with the style and content of the previous text. You can break your response in multiple paragraphs if you think it's appropriate.

Be creative but also try to be consistent with the style and content of the previous text.

You'll receive messages with the text you have to edit, and you'll have to respond with the edited text.
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

--- Tries to continue the text by taking the last `max_previous_words` words, and the next `max_next_words` words using GPT-4 or claude.
function M.continue()
    local prev_words, next_words = functions.get_words_around_cursor(options.max_previous_words, options.max_next_words)
    print("Prev words: " .. vim.inspect(prev_words))
    print("Next words: " .. vim.inspect(next_words))

    if prev_words == nil or next_words == nil then
        return
    end

    local prompt = ""
    if #prev_words > 0 then
        prompt = prompt .. table.concat(prev_words, " ")
    end
    prompt = prompt .. "<|continue|>"
    if #next_words > 0 then
        prompt = prompt .. table.concat(next_words, " ")
    end

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

    -- Get the current line and column number
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local text = vim.api.nvim_get_current_line()

    local before = text:sub(1, col)
    local after = text:sub(col + 1)

    -- If there are more lines in the lines, we add them without replacing existing lines.
    if #lines == 1 then
        lines[1] = before .. lines[1]
        lines[1] = lines[1] .. after
        -- Append the lines between at the cursor on the current line.
        vim.api.nvim_buf_set_lines(0, line - 1, line, false, { lines[1] })
    else
        lines[1] = before .. lines[1]
        lines[#lines] = lines[#lines] .. after
        -- Get all the lines on the buffer
        local buffer = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        -- Add the lines from the current cursor position
        vim.api.nvim_buf_set_lines(0, line - 1, line + #lines - 1, false, lines)
        -- Add the remaining buffer lines
        vim.api.nvim_buf_set_lines(0, line + #lines, #buffer + #lines - 1, false,
            functions.slice_table(buffer, line, #buffer))
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
    max_previous_words = 100,
    max_next_words = 100,
    max_tokens = 100,
})

---
return M
