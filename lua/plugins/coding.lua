return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
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
      },
    },
  },
  {
    "f-person/git-blame.nvim",
    config = function()
      require("gitblame").setup({
        message_template = "    <author>   <date>   <summary>",
        date_format = "%r",
        message_when_not_committed = "  󱋽  uncommitted",
        -- added custom highlight group to LazyVim's options.lua:
        -- :highlight GitBlame cterm=italic gui=italic guifg=#565f89 guibg=#292e42
        -- :hi link Keyword GitBlame
        highlight_group = "GitBlame",
      })
    end,
  },
}
