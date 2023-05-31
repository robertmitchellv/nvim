return  {
  "quarto-dev/quarto-nvim",
  dev = false,
  config = function()
    local quarto = require("quarto")
    quarto.setup{
      lspFeatures = {
        enabled = true,
        languages = { "r", "python", "julia", "bash" },
        chunks = "curly",
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      keymap = {
        hover = "K",
        definition = "gd",
        rename = "<leader>cr",
        references = "gr"
      }
    }
  end,
  dependencies = {
    { "jmbuhr/otter.nvim" },
    { "hrsh7th/nvim-cmp" }
  }
}
