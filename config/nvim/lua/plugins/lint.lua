return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  opts = {
    -- LazyVim extension to easily override linter options
    -- or add custom linters.
    ---@type table<string,table>
    linters = {
      -- -- Example of using selene only when a selene.toml file is present
      markdownlint = {
        -- `condition` is another LazyVim extension that allows you to
        -- dynamically enable/disable linters based on the context.
        condition = function(ctx)
          return vim.fs.find({ ".mdlrc" }, { path = ctx.filename, upward = true })[1]
        end,
      },
    },
  },
}
