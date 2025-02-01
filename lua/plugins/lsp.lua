return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- 1. Set up Mason first
      local mason = require("mason")
      mason.setup({
        ui = {
          icons = {
            package_installed = " ",
            package_pending = " ",
            package_uninstalled = " ",
          },
          border = "rounded",
        },
      })

      -- 2. Set up mason-lspconfig
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = {
          "ansiblels",
          "bashls",
          "cssls",
          "docker_compose_language_service",
          "dockerls",
          "html",
          "jsonls",
          "lemminx",
          "lua_ls",
          "marksman",
          "ruff",
          "taplo",
          "ts_ls",
          "yamlls",
        },
        automatic_installation = true,
      })

      -- 3. Additional Mason packages that aren't LSP servers
      local registry = require("mason-registry")
      local function ensure_installed()
        local packages = {
          "prettierd",
          "curlylint",
        }

        for _, package in ipairs(packages) do
          local p = registry.get_package(package)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      registry.refresh(function()
        ensure_installed()
      end)

      -- 4. Set up LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf }
          -- displays hover information about the symbol under the cursor in a floating window
          vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
          -- jumps to the definition of the symbol under the cursor
          vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
          -- jumps to the declaration of the symbol under the cursor. Some servers don't implement this feature
          vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
          -- lists all the implementations for the symbol under the cursor in the quickfix window
          vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
          -- jumps to the definition of the type of the symbol under the cursor
          vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
          -- lists all the references to the symbol under the cursor in the quickfix window
          vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
          -- displays signature information about the symbol under the cursor in a floating window
          vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
          -- renames all references to the symbol under the cursor
          vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
          -- format code in current buffer
          vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
          -- selects a code action available at the current cursor position
          vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

          -- vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
          -- vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
          -- vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
        end,
      })

      -- 5. Set up capabilities
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 6. Configure individual servers
      local lspconfig = require("lspconfig")

      -- Configure each server
      lspconfig.ansiblels.setup({ capabilities = capabilities })
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.docker_compose_language_service.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.jsonls.setup({ capabilities = capabilities })
      lspconfig.kulala_ls.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "describe", "it", "before_each", "after_each" },
            },
          },
        },
      })
      lspconfig.marksman.setup({ capabilities = capabilities })
      lspconfig.ruff.setup({
        capabilities = capabilities,
        settings = {
          ruff = {
            keys = {
              {
                "<leader>co",
                function()
                  vim.lsp.buf.code_action({
                    apply = true,
                    context = {
                      only = { "source.organizeImports" },
                      diagnostics = {},
                    },
                  })
                end,
                desc = "Organize Imports",
              },
            },
          },
        }
      })
      lspconfig.taplo.setup({ capabilities = capabilities })
      lspconfig.ts_ls.setup({ capabilities = capabilities })
      lspconfig.yamlls.setup({ capabilities = capabilities })
    end,
  },
}
