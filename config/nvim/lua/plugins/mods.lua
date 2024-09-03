return {
  "cloudbridgeuy/mods",
  dependencies = {
    "j-hui/fidget.nvim",
  },
  dev = true,
  opts = {
    aws = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "Amazon Web Services, AWS, awscli, `awscli`, `aws`, aws" }',
    },
    es = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "ElasticSearch (Elasticsearch) and OpenSearch (Opensearch)" }',
    },
    vim = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "Lua (`lua`) and NeoVim (`vim`, `nvim`, `vimscript`)" }',
    },
    js = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "JavaScript (`js`, `javascript`) and TypeScript (`ts`, `typescript`)" }',
    },
    sql = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "SQL Transactional Databases like SQLite `sqlite`, PostgreSQL `postgresql` `postgres`, MySQL `mysql`" }',
    },
    ci = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "CI/CD tools, Jenkins, Kubernetes, GitHub, Git, GitHub Actions, Terraform, Ansible, Tekton, Infrastructure as Code, IaC" }',
    },
    google = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "Google Cloud Compute, gcloud, gsutil" }',
    },
    k8s = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "Kubernetes, k8s, helm, kustomize, Cloud Native software developent" }',
    },
    rust = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "Rust (rust, `rust`), cargo, `cargo`, `clap`, `serde`, `thiserror`, `anyhow`, `tokio`" }',
    },
    go = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "Go (golang), `cobra`, `viper`, `lipgloss`, `bubbletea`" }',
    },
    python = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "Python (`python`), `fastapi`, `typer`, `typings`, `pydantic`" }',
    },
    bash = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "Bash (`bash`), shell, `zsh`, `dash`, `sh`, `awk`, `sed`, `jq`, `grep`" }',
    },
    prompter = {
      preset = "sonnet",
      template = "prompter",
    },
    awscli = {
      preset = "copilot",
      template = "tech-agent",
      vars = '{ "technologies": "AWS, awscli, `awscli`, `aws`, aws" }',
      suffix = [[
      I only respond with the `awscli` commands or AWS SDK examples and nothing else.

      I never add any contents, nor do I greet or address the user in any way.

      I understand that time is valuable so any bit of text that is not directly directed to the question I discard it.
]],
    },
  },
}
