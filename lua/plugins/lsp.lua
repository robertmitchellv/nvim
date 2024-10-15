return {
  -- this is for DAPs, linters, and formatters
  -- LSP goes in the next section
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "beautysh",
        "css-lsp",
        "curlylint",
        "debugpy",
        "deno",
        "docformatter",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "fixjson",
        "gh",
        "gitlint",
        "grammarly-languageserver",
        "helm-ls",
        "html-lsp",
        "jq",
        "json-lsp",
        "julia-lsp",
        "lemminx",
        "ltex-ls",
        "lua-language-server",
        "luacheck",
        "luaformatter",
        "marksman",
        "prettier",
        "ruff",
        "ruff-lsp",
        "shellcheck",
        "shfmt",
        "sqlls",
        "stylua",
        "taplo",
        "terraform-ls",
        "typescript-language-server",
        "vim-language-server",
        "write-good",
        "xmlformatter",
        "yaml-language-server",
        "yamllint",
        "yq",
        "zls",
      },
    },
  },

  -- LSP goes here; DAP, linter, formatters go in mason
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type lspconfig.options
      servers = {
        ansiblels = {},
        bashls = {},
        cssls = {},
        denols = {},
        dockerls = {},
        grammarly = {},
        helm_ls = {},
        html = {},
        jsonls = {},
        julials = {},
        lemminx = {},
        ltex = {},
        lua_ls = {},
        marksman = {},
        ruff_lsp = {
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
              desc = "Organizae Imports",
            },
          },
        },
        sqlls = {},
        terraformls = {},
        tsserver = {},
        yamlls = {},
      },
      setup = {
        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- disable hover in favor of Pyright
              -- client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },
}
