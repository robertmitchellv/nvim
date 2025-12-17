-- icons
local icons = require("utils.icons")

return {
  -- this if **only** for things that i don't want to set up
  -- via LazyExtras. so in the case of python tooling, i'm
  -- setting this up in a custom way. for everything else
  -- that i'm happy with out of the box, LazyExtras -> lazy.lua
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = icons.mason.installed,
          package_pending = icons.mason.pending,
          package_uninstalled = icons.mason.uninstalled,
        },
      },
      ensure_installed = {
        "lemminx",
        "ruff",
        "ty",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- working without this sure is ruff
        ruff = {
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
        },
        -- thank you
        ty = {
          -- custom stuff here?
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    opts = { diagnostics = { virtual_text = false } },
  },
}
