return {
  -- 1. mason 2.0
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = " ",
          package_pending = " ",
          package_uninstalled = " ",
        },
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Ensure formatters and linters are installed
      local registry = require("mason-registry")
      local ensure_installed = {
        -- formatters
        "djlint",
        "prettier",
        "prettierd",
      }

      registry.refresh(function()
        for _, tool in ipairs(ensure_installed) do
          local p = registry.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- 2. on nvim >= 11 we can use new lsp api
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
    },
  },

  -- 3. mason lspconfig (after both are set up)
  --    relies on mason >= 2.0 and nvim >= 11
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        -- lsps
        "ansiblels",
        "bashls",
        "cssls",
        "docker_compose_language_service",
        "dockerls",
        "html",
        "jinja_lsp",
        "jsonls",
        "lemminx",
        "lua_ls",
        "marksman",
        "pyright",
        "ruff",
        "taplo",
        "ts_ls",
        "yamlls",
      },
      automatic_enable = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- lsp keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
  },
}
