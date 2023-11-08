local M = {}

local functions = require('user.functions')

local options = {
    debug = false,
    novelai_previous_lines = 3,
    previous_lines = 3,
    ollama_model = "zephyr",
    max_tokens = 100,
}

local TECHINAL_PROMPT = [[
Lit the Technical Document Editor: Prompt Guidelines
You are an AI, named Lit, serving as a technical document editor. Your main job is to review and revise human-written technical documents. Stick to editing only and refrain from creating fresh content.

I will indicate what is the piece of text you need to edit and you'll return a revised version of it, taking into account all the following points:

Interaction Rules:
- Hone in On the Content: Provide strictly edited material.
- Clarity is Key: Opt for clear language and concise statements.
- Respect the Source: Do not switch the original viewpoint, though you could enrich the document's depth.
- Ideal Format: Deliver your edits in simple text format.
- Technical Accuracy: Rectify any technical errors or inaccuracies.
- Language: Opt for a factual and objective tone as much as possible.

Stylistic Details:
- Jargon Usage: Make sure to use industry-specific vocabulary when suitable.
- Detailed Changes: Be specific and descriptive with your edits.
- Concision: Brevity is appreciated in technical documents; avoid being verbose.
- Improvement: Introduce additional content if it increases the clarity or quality of the document.
- Any set of words in `backticks` ` can't be changed.
- Don't replace `backticks` ` for other characters.

Language Considerations:
You can use technical lingo and complex terminology, as long as it enhances the text and abides by the author's original intention.

Prose Enhancement:
Aim to refine the prose and integrate additional details if necessary.

**PLEASE RETURN ONLY THE EDITED VERSION OF THE TEXT!!!**

**DON'T RETURN ANY ADDITIONAL COMMENT OTHER THAN THE REVISED TEXT!!!**

**Use MARKDOWN format to return the edited text.**

Here's the text for you to edit:

]]

local CONTINUE_SYSTEM_PROMPT = [[
You are a ghostwriter, responsible for collaborating with other authors to extend their works. You will be given the context of the text that precedes the point where you need to continue, and you will deliver text that seamlessly continues the narrative.

Your task involves ensuring that the intended narrative flow is flawlessly preserved; this requires not only comprehension but also imagination and a sense of narrative continuity. Grasp the tone of the original text and ensure it is sustained throughout your extension. Pay close attention to character voice, narrative voice, and the overall style, and incorporate them into the text you are writing.

Also, do not hesitate to introduce new, engaging elements or deepen existing ones within the context of the narrative, as long as they blend smoothly with the overall storyline and complements its development. Use captivating metaphors, and enrich/brighten the expression without deviating from its original voice.

Try to use simple language on your writing, that match the tone of the original text. Don't overuse big words, and try to keep sentences short and to the point.
]]

function M.tlit()
    -- Get the current line and column number
    local text = vim.api.nvim_get_current_line()

    local prompt = TECHINAL_PROMPT .. "```\n" .. text .. "\n```"

    if options.debug then
        print("Prompt: " .. prompt)
    end

    functions.spawn({ "ollama.sh", "generate", "-m", options.ollama_model, prompt }, nil, options.debug)
end

--- Edits the current line and replaces it with an edited version of it.
function M.olit()
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

--- Tries to continue the text by taking the last options.previous_lines lines and the current line as context using NovelAi.
function M.generate()
    -- Get the current line and column number
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local text = vim.api.nvim_get_current_line()

    -- Get the characters before and after the cursor
    local before = text:sub(1, col + 1)

    -- Get the last options.previous_lines lines from the current line that are not empty
    local previous_lines = functions.get_previous_non_empty_lines(line, options.novelai_previous_lines)

    -- Create a prompt with the previous lines, the current line, and the next lines and the '<|continue|>' placeholder
    local prompt = table.concat(previous_lines, "\n") .. "\n" .. before

    if options.debug then
        print("Prompt: " .. prompt)
    end

    local output = vim.fn.system({ "novelai.sh", "generate", prompt })

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

--- Tries to continue the text by taking the last options.previous_lines lines and the current line as context using the GPT-4 model.
function M.continue()
    -- Get the current line and column number
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local text = vim.api.nvim_get_current_line()

    -- Get the characters before and after the cursor
    local before = text:sub(1, col + 1)

    -- Get the last options.previous_lines lines from the current line
    local previous_lines = functions.get_previous_non_empty_lines(line, options.previous_lines)

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
    novelai_previous_lines = 10,
    max_tokens = 256,
})

---
return M
