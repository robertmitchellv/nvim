return {
  "stevearc/conform.nvim",
  enabled = true,
  event = { "BufWritePre" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        http = { "kulala_ls" },
        javascript = { "prettierd", "eslint_d" },
        javascriptreact = { "prettierd" },
        json = { "prettierd" },
        lua = { "stylua" },
        markdown = { "markdownlint" },
        python = { "ruff_fix", "ruff_format" },
        sh = { "shfmt" },
        toml = { "taplo" },
        typescript = { "prettierd", "eslint_d" },
        typescriptreact = { "prettierd" },
        yaml = { "yamlfmt" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },
    })
  end,
  cmd = { "ConformInfo" },
}
