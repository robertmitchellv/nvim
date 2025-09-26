return {
  -- 1. mason 2.0
  -- *  used for lsp and formatter/linter management
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
        "sqlfluff",
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

  -- 2. nvim-lspconfig for easy lsp setup
  -- *  on nvim >= 11 we can use new lsp api
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
    },
  },

  -- 3. mason lspconfig (after both are set up)
  -- *  mason-lspconfig for wiring mason and lspconfig together
  -- *  relies on mason >= 2.0 and nvim >= 11
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
        "taplo",
        "ts_ls",
        "yamlls",
      },
      automatic_enable = {
        exclude = {
          "basedpyright",
          "ruff",
        },
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- get lspconfig
      local lspconfig = require("lspconfig")

      -- try to keep lsp log velocity down
      vim.lsp.set_log_level("warn")

      -- configure ruff for linting; not completion
      lspconfig.ruff.setup({
        init_options = {
          settings = {
            -- ruff settings if needed
            logLevel = "error",
          },
        },
      })

      -- configure basedpyright for completion/signature help
      lspconfig.basedpyright.setup({
        settings = {
          basedpyright = {
            analysis = {
              -- type checking modes (from least to most strict):
              -- "off" - no type checking
              -- "basic" - basic type checking (assignments, function calls)
              -- "standard" - mid-level checking (most common)
              -- "strict" - high level (close to mypy's strict mode)
              -- "recommended" - most rules turned on
              -- "all" - maximum strictness
              typeCheckingMode = "recommended",

              -- useful analysis settings
              -- -> suggests auto-imports during completion
              autoImportCompletions = true,
              -- -> include type info from libraries
              useLibraryCodeForTypes = true,
              -- -> "openFilesOnly" or "workspace"
              diagnosticMode = "openFilesOnly",

              -- error customization
              diagnosticSeverityOverrides = {
                -- customize specific message severities:
                -- "none" - disable message
                -- "information" - informational only
                -- "warning" - warnings
                -- "error" - errors

                -- -> instead of error
                reportOptionalSubscript = "warning",
                reportOptionalMemberAccess = "warning",
                reportOptionalCall = "warning",

                -- -> type completeness
                reportUnknownParameterType = true,
                reportUnknownVariableType = true,
                reportUnknownMemberType = false, -- often noisy with dynamic code

                -- -> unused code
                reportUnusedCallResult = "none",
                -- -> shows as hint in editor
                reportUnusedVariable = "hint",
                reportUnusedImport = "hint",

                -- basedpyright exclusive settings
                -- -> warn about implicit Any types
                reportAny = "warning",
                -- -> warn about explicit Any usage
                reportExplicitAny = "warning",
                reportUnreachable = "warning",
              },

              -- common settings
              -- -> Stricter typing for lists
              strictListInference = true,
              -- -> Stricter typing for dicts
              strictDictionaryInference = true,
              -- -> Stricter typing for sets
              strictSetInference = true,
              strictGenericNarrowing = true,

              -- what to ignore
              ignore = {
                -- ignore specific files/directories
                -- -> ignore test directories
                "**/tests/**",
                "**/__pycache__/**",
              },

              -- type checking customization
              reportMissingImports = true,
              -- -> often turned off due to many missing stubs
              reportMissingTypeStubs = false,
              -- -> can be noisy with dynamic code
              reportUnknownMemberType = false,
              reportUnknownParameterType = true,
              reportUnknownVariableType = true,
              reportUntypedFunctionDecorator = true,

              -- extra features
              inlayHints = {
                -- -> show parameter names in function calls
                callArgumentNames = true,
                -- -> show return types
                functionReturnTypes = true,
                -- -> show variable types
                variableTypes = true,
                genericTypes = false,

                -- experimental
                -- -> for python >= 3.9
                deprecateTypingAliases = true
              },
            },
          },
        },
        init_options = {
          python = {
            pythonVersion = "3.13",
            pythonPlatform = "Linux",
          },
        },
      })

      -- disable ruff hover in favor of basedpyright
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == "ruff_lsp" then
            -- disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
        end,
        desc = "LSP: Disable hover capability from Ruff",
      })

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

  -- batteries included sqlfluff in neovim
  {
    "michhernand/simple-sqlfluff.nvim",
    keys = {
      { "<leader>Sf", "<cmd>SQLFluffFormat<CR>",  desc = "Format w/ SQLFluff" },
      { "<leader>St", "<cmd>SQLFluffToggle<CR>",  desc = "Toggle SQLFluff Linting" },
      { "<leader>Se", "<cmd>SQLFluffEnable<CR>",  desc = "Enable SQLFluff Linting" },
      { "<leader>Sd", "<cmd>SQLFluffDisable<CR>", desc = "Disable SQLFluff Linting" },
    },
    opts = {}
  }
}
