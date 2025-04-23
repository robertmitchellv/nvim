return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- 1. set up Mason first
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

      -- 2. set up mason-lspconfig
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = {
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
        automatic_installation = true,
      })

      -- 3. additional Mason packages that aren't LSP servers
      local registry = require("mason-registry")
      local function ensure_installed()
        local packages = {
          "djlint",
          "prettierd",
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

      -- 4. set up LSP keymaps
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
          vim.keymap.set("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
          -- format code in current buffer
          vim.keymap.set({ "n", "x" }, "<leader>f", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
          -- selects a code action available at the current cursor position
          vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

          -- vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
          -- vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
          -- vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
        end,
      })

      -- 5. set up capabilities
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 6. configure individual servers
      local lspconfig = require("lspconfig")

      -- configure each server
      lspconfig.ansiblels.setup({ capabilities = capabilities })
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.docker_compose_language_service.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.jinja_lsp.setup({ capabilities = capabilities })
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
        on_attach = function(client, bufnr)
          -- Organize imports keybinding
          vim.keymap.set("n", "<leader>co", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.organizeImports" },
                diagnostics = {},
              },
            })
          end, { buffer = bufnr, desc = "Organize Imports" })

          -- Add rename keybinding if you want to use <leader>cr
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
        end
      })
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true
            }
          }
        }
      })
      lspconfig.taplo.setup({ capabilities = capabilities })
      lspconfig.ts_ls.setup({ capabilities = capabilities })
      lspconfig.yamlls.setup({ capabilities = capabilities })
    end,
  },
}
