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
        "basedpyright",
        "lemminx",
        "ruff",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- for a more feature rich pyright experience
        basedpyright = {
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
                typeCheckingMode = "basic",

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
                  reportOptionalSubscript = "none",
                  reportOptionalMemberAccess = "none",
                  reportOptionalCall = "none",

                  -- -> type completeness
                  reportUnknownParameterType = false,
                  reportUnknownVariableType = false,
                  reportUnknownMemberType = false,

                  -- -> unused code
                  reportUnusedCallResult = "none",
                  -- -> shows as hint in editor
                  reportUnusedVariable = "none",
                  reportUnusedImport = "none",

                  -- basedpyright exclusive settings
                  -- -> hint about implicit Any types
                  reportAny = "none",
                  -- -> hint about explicit Any usage
                  reportExplicitAny = "none",
                  reportUnreachable = "none",
                },

                -- common settings
                -- -> stricter typing for lists
                strictListInference = true,
                -- -> stricter typing for dicts
                strictDictionaryInference = true,
                -- -> stricter typing for sets
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
                reportMissingImports = false,
                -- -> often turned off due to many missing stubs
                reportMissingTypeStubs = false,
                -- -> can be noisy with dynamic code
                reportUntypedFunctionDecorator = false,

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
                  deprecateTypingAliases = true,
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
        },
        -- working without this sure is ruff
        ruff = {
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
        },
      },
      setup = {
        ruff = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff" then
              client.server_capabilities.hoverProvider = false
            end
          end, "ruff")
        end,
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
