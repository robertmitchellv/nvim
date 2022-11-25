local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

if not packer_plugins["cmp-nvim-lsp"].loaded then
  vim.cmd([[packadd cmp-nvim-lsp]])
end
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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
    prefix = "🔥",
    source = true,
  },
})

lspconfig.pyright.setup({
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
  capabilities = capabilities,
})

lspconfig.sumneko_lua.setup({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` globalglobals
        globals = {'vim'},
      },
      workspace = {
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
  -- "bicep",
  -- "clangd",
  "cssls",
  "denols",
  "dockerls",
  "eslint",
  -- "gopls",
  "html",
  "jsonls",
  "tsserver",
  -- "julials",
  -- "ltex",
  -- "sumneko_lua",
  -- "marksman",
  "pyright",
  -- "r_language_server",
  -- "rust_analyzer",
  "sqlls",
  "taplo",
  "tailwindcss",
  -- "terraformls",
  -- "volar",
  -- "lemminx",
  "yamlls",
  -- "zls"
}

for _, server in ipairs(servers) do
  lspconfig[server].setup({
    capabilities = capabilities,
  })
end
