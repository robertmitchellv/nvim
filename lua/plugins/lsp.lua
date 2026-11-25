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
      -- tiny-inline-diagnostic renders these instead
      diagnostics = { virtual_text = false },
      servers = {
        -- for a more feature rich pyright experience
        -- NOTE: a project's `[tool.basedpyright]` or `pyrightconfig.json` replaces
        -- these settings wholesale--and options like `strictListInference` or
        -- `pythonVersion` can _only_ be set there, not from the editor
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
                -- NOTE: every `report*` rule goes in here--basedpyright ignores
                -- them anywhere else in `analysis`
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

                  -- type checking customization
                  reportMissingImports = false,
                  -- -> often turned off due to many missing stubs
                  reportMissingTypeStubs = false,
                  -- -> can be noisy with dynamic code
                  reportUntypedFunctionDecorator = false,

                  -- basedpyright exclusive settings
                  -- -> hint about implicit Any types
                  reportAny = "none",
                  -- -> hint about explicit Any usage
                  reportExplicitAny = "none",
                  reportUnreachable = "none",
                },

                -- what to ignore--silences **all** diagnostics for these paths
                ignore = {
                  -- ignore specific files/directories
                  -- -> ignore test directories
                  "**/tests/**",
                  "**/__pycache__/**",
                },

                -- extra features
                inlayHints = {
                  -- -> show parameter names in function calls
                  callArgumentNames = true,
                  -- -> show return types
                  functionReturnTypes = true,
                  -- -> show variable types
                  variableTypes = true,
                  genericTypes = false,
                },
              },
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
          Snacks.util.lsp.on({ name = "ruff" }, function(_, client)
            client.server_capabilities.hoverProvider = false
          end)
        end,
      },
    },
  },
  -- no `format_on_save` here--LazyVim owns format-on-save (toggle with `<leader>uf`)
  -- and strips that option with a warning
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
      },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {},
  },
}
