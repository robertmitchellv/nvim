-- load lspconfig safely
local status_lspconfig, lspconfig = pcall(require, "lspconfig")
if not status_lspconfig then
  return
end

-- to enable autocompletion
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- the lsp signs i want to use
local signs = {
  Error = " ",
  Warn = " ",
  Info = " ",
  Hint = " ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  virtual_text = {
    prefix = " ",
    source = true,
  },
})

-- markdown
lspconfig.marksman.setup({
  filetypes = { "md" },
  capabilities = capabilities,
})

-- python
lspconfig.pyright.setup({
  capabilities = capabilities,
  -- pyright configflags
  flags = { debounce_text_changes = 150 },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "basic",
      },
    },
  },
})

-- r
lspconfig.r_language_server.setup({
  filetypes = { "r", "rmd" },
  capabilities = capabilities,
})

-- rust
lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
})

-- lua
lspconfig.sumneko_lua.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you"re using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` globalglobals
        globals = {"vim"},
      },
      workspace = {
        -- Don't show message about luassert
        checkThirdParty = false,
        -- Make the server aware of Neovim runtime fileslibrary
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifiertelemetry
      telemetry = {
        enable = false,
      },
    },
  },
})

local servers = {
  "angularls",
  "ansiblels",
  "astro",
  "bashls",
  "clangd",
  "cssls",
  "denols",
  "dockerls",
  "eslint",
  "gopls",
  "html",
  "jsonls",
  "julials",
  "lemminx", -- xml
  "ltex", -- latex
  -- "marksman", -- markdown
  -- "pyright",
  -- "r_language_server",
  -- "rust_analyzer",
  "sqlls",
  -- "sumneko_lua", -- lua
  "taplo", -- toml
  "tailwindcss",
  "terraformls",
  "tsserver", -- ts and js
  "volar", -- vue
  "yamlls",
}

for _, server in ipairs(servers) do
  lspconfig[server].setup({
    capabilities = capabilities,
  })
end
