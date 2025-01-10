local EXPLAIN_TEMPLATE = [[I have the following code from {{filename}}:

```{{filetype}}
{{selection}}
```

Please respond by explaining the code above.
]]

local shared_tech_agent_system_prompt = [[**Guidelines for Interaction:**

1. **Be Concise:** Provide clear, direct answers.
2. **Stay Relevant:** Focus directly on the query at hand.
3. **Use Technical Language:** Employ industry-specific terminology appropriate for experienced developers.
4. **Assume Expertise:** Consider that the user has an advanced understanding of the subject.
5. **Avoid Redundancy:** Do not repeat code snippets already shared; focus on modifications or new suggestions.
6. **Incorporate Examples:** Include practical examples when they aid in clarifying the response.
7. **Get to the Points:** Avoid introductions and conclussions.

Please use markdown to format your answers. Use code fences or triple backticks for code examples.]]

local function tech_agent(technologies)
  return "As an AI expert trained in "
    .. technologies
    .. ", I am here to assist senior software developers, following these instructions.\n"
    .. shared_tech_agent_system_prompt
end

return {
  "robitx/gp.nvim",
  enabled = true,
  config = function()
    local conf = {
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1/chat/completions",
          secret = os.getenv("OPENAI_API_KEY"),
        },

        copilot = {
          endpoint = "https://api.githubcopilot.com/chat/completions",
          secret = {
            "bash",
            "-c",
            "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
          },
        },

        ollama = {
          endpoint = "http://localhost:11434/v1/chat/completions",
        },

        googleai = {
          endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
          secret = os.getenv("GOOGLE_API_KEY"),
        },

        anthropic = {
          endpoint = "https://api.anthropic.com/v1/messages",
          secret = os.getenv("ANTHROPIC_API_KEY"),
        },
      },

      agents = {
        {
          provider = "anthropic",
          name = "tech-anthropic",
          chat = true,
          command = false,
          model = { model = "claude-3-5-sonnet-20240620" },
          system_prompt = tech_agent(
            "Software Development, DevOps, Machine Learning, Data Analytics, Systems Engineering, Networking, Cloud Computing, Rust, Go, Python, TypeScript, JavaScript, Bash"
          ),
        },
        {
          provider = "googleai",
          name = "gemini",
          chat = true,
          command = false,
          model = { model = "gemini-pro", temperature = 1.1, top_p = 1 },
          system_prompt = tech_agent(
            "Software Development, DevOps, Machine Learning, Data Analytics, Systems Engineering, Networking, Cloud Computing, Rust, Go, Python, TypeScript, JavaScript, Bash"
          ),
        },
        {
          name = "tech",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent(
            "Software Development, DevOps, Machine Learning, Data Analytics, Systems Engineering, Networking, Cloud Computing, Rust, Go, Python, TypeScript, JavaScript, Bash"
          ),
        },
        {
          name = "es",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent(
            "Elasticsearch, `es`, `elasticsearch`, Logstash, `logstash, Kibana, `kibana`, OpenSearch, `opensearch`, Amazon OpenSearch"
          ),
        },
        {
          name = "php",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent("PHP, `php`, php"),
        },
        {
          name = "lua",
          provider = "anthropic",
          chat = true,
          command = false,
          model = { model = "claude-3-5-sonnet-20240620" },
          system_prompt = tech_agent("Lua, lua, NVIM, NeoVim, nvim, `nvim`, Vim, `vim`, vim, luarocks"),
        },
        {
          name = "js",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent(
            "JavaScript, Javascript, javascript, `javascript, `js`, js, Typescript, TypeScript, `ts`, typescript, `typescript`, React, `react`, ExpressJS, `express`, `expressjs`, `zod`"
          ),
        },
        {
          name = "sql",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent(
            "SQL, PostgreSQL, `postgres`, `postgresql, MySQL, mysql, `mysql`, SQlite, Sqlite, sqlite, `sqlite`, `sqlite3`"
          ),
        },
        {
          name = "ci",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent(
            "CI/CD Tools, ci/cd, Jenkins, jenkins, Kubernetes, kubernetes, `kubernetes, `k8s`, GitHub, github, Git, `git`, git, GitHub Actions, Terraform, terraform, `terraform`, HCL, `hcl`, Ansible, Tekton, `tekton`, tekton, Infrastructure as Code, IaC, `iac`"
          ),
        },
        {
          name = "hcl",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent(
            "Terraform, terraform, `terraform`, HCL, `hcl`, Packer, packer, `packer`, HashiCorp, `hashicorp`"
          ),
        },
        {
          name = "aws",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent(
            "Amazon, amazon, AWS, aws, `aws`, AWS CLI, AWS Cli, aws cli, `awscli`, awscli, `lambda`, `ec2`, `s3`, `sqs`, `sns`, `ecs`, `fargate`"
          ),
        },
        {
          name = "gcloud",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent(
            "Google, Google Cloud Computing, GCP, `gcp`, gcp, `gcloud`, gcloud, gsutils, `gsutils`"
          ),
        },
        {
          name = "k8s",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent("Kubernetes, kubernetes, `kubernetes, `k8s`, `kubectl`, kubectl"),
        },
        {
          name = "rust",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent("Rust, rust, `rust`, `rs`, clap, serde, axum, anyhow, color_eyre, reqwest"),
        },
        {
          name = "go",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent("Go, go, `go`, Golang, golang, `golang`, cobra, viper"),
        },
        {
          name = "bash",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent("Bash, bash, `bash`, Shell, shell, sh, zsh, Zsh, `zsh`"),
        },
        {
          name = "python",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent("Python, python, `python`, `python3`, typer, fastapi, pydantic"),
        },
        {
          name = "auth",
          provider = "copilot",
          chat = true,
          command = false,
          model = { model = "gpt-4o" },
          system_prompt = tech_agent(
            "RBAC, Role Based Access Control, Authentication, Authorization, Audit, AAA, Okta, OpenFGA, ReBAC, Relationship Based Access Control"
          ),
        },
      },

      -- prefix for all commands
      cmd_prefix = "Gp",
      -- log file location
      log_file = vim.fn.stdpath("log"):gsub("/$", "") .. "/gp.nvim.log",
      -- write sensitive data to log file for	debugging purposes (like api keys)
      log_sensitive = false,
      -- directory for persisting state dynamically changed by user (like model or persona)
      state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/persisted",

      -- default agent names set during startup, if nil last used agent is used
      default_chat_agent = nil,

      -- directory for storing chat files
      chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
      -- chat user prompt prefix
      chat_user_prefix = "💬:",
      -- chat assistant prompt prefix (static string or a table {static, template})
      -- first string has to be static, second string can contain template {{agent}}
      -- just a static string is legacy and the [{{agent}}] element is added automatically
      -- if you really want just a static string, make it a table with one element { "🤖:" }
      chat_assistant_prefix = { "🤖:", "[{{agent}}]" },

      -- The banner shown at the top of each chat file.
      chat_template = require("gp.defaults").short_chat_template,
      -- chat topic generation prompt
      chat_topic_gen_prompt = "Summarize the topic of our conversation above in two or three words. Respond only with those words.",
      -- chat topic model (string with model name or table with model name and parameters)
      -- explicitly confirm deletion of a chat file
      chat_confirm_delete = false,
      -- conceal model parameters in chat
      chat_conceal_model_params = true,

      hooks = {
        -- Explains the current code
        Explain = function(gp, params)
          local template = EXPLAIN_TEMPLATE
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.popup, agent, template)
        end,

        -- Edits a given text using a literary agent.
        LitEdit = function(gp, params)
          local template = [[{{selection}}]]
          local agent = gp.get_chat_agent("lit-edit-agent")

          gp.Prompt(
            params,
            gp.Target.rewrite,
            agent,
            template,
            nil, -- Command will run directly without any prompting for user input.
            nil -- No pre-defined instructions (e.g. speech-to-text fro Whisper.)
          )
        end,

        -- Edits a given text using a literary agent.
        LitAppend = function(gp, params)
          local template = [[{{selection}}]]
          local agent = gp.get_chat_agent("lit-append-agent")

          gp.Prompt(
            params,
            gp.Target.append,
            agent,
            template,
            nil, -- Command will run directly without any prompting for user input.
            nil -- No pre-defined instructions (e.g. speech-to-text fro Whisper.)
          )
        end,

        -- GpInspectPlugin provides a detailed inspection of the plugin state
        InspectPlugin = function(plugin, params)
          local bufnr = vim.api.nvim_create_buf(false, true)
          local copy = vim.deepcopy(plugin)
          local key = copy.config.openai_api_key or ""
          copy.config.openai_api_key = key:sub(1, 3) .. string.rep("*", #key - 6) .. key:sub(-3)
          local plugin_info = string.format("Plugin structure:\n%s", vim.inspect(copy))
          local params_info = string.format("Command params:\n%s", vim.inspect(params))
          local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
          vim.api.nvim_win_set_buf(0, bufnr)
        end,
      },
    }

    require("gp").setup(conf)

    -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
  end,
}
