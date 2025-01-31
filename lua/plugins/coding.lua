return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("conform").setup({
        formatters = {
          kulala = {
            command = "kulala-fmt",
            args = { "$FILENAME" },
            stdin = false,
          },
        },
      })
    end,
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        python = {
          "ruff_fix",
          "ruff_format",
        },
        toml = { "taplo" },
        http = { "kulala" },
      },
      format_on_save = true,
    },
  },
}
