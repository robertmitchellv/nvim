-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require("core.pack").register_plugin
local conf = require("modules.completion.config")

local enable_lsp_filetype = {
  -- ansible
  "yaml.ansible",
  -- astro
  "astro",
  -- bash
  "sh",
  -- clangd
  "c", "cpp", "objc", "objcpp", "cuda",
  -- cssls
  "css", "scss", "less",
  -- dockerls
  "dockerfile", "containerfile",
  -- go
  "go", "gomod", "gowork", "gotmpl",
  -- html
  "html",
  -- js, ts, + denols 
  "javascript", "javascriptreact", "javascript.jsx",
  "typescript", "typescriptreact", "typescript.tsx",
-- jsonls
  "json", "jsonc",
  -- julia
  "julia",
  -- python
  "python",
    -- marksman
  "markdown",
  -- rsats
  "r", "rmd",
  -- rust
  "rust",
  -- sqlls
  "sql", "mysql", "sqlite3",
  -- lua
  "lua",
  -- quarto
  "qmd",
  -- svelte 
  "svelte",
  -- tailwindcss
  "astro-markdown", "ejs", "handlebars", "liquid", "mdx", "mustache",
  "postcss", "stylus", "sugarss", "reason", "rescript",
  -- taplo
  "toml",
  -- terraform
  "terraform",
  -- volar 
  "vue",
  -- xml = lemminx
  "xml", "xsd", "xsl", "xslt", "svg",
  -- yamlls 
  "yaml", "yaml.docker-compose",
}

plugin({
  "williamboman/mason.nvim",
  config = conf.mason,
})

plugin({
  "williamboman/mason-lspconfig.nvim",
  config = conf.mason_lspconfig,
})

plugin({
  "neovim/nvim-lspconfig",
  -- used filetype to lazyload lsp
  -- config your language filetype in here
  ft = enable_lsp_filetype,
  config = conf.nvim_lsp,
})

plugin({ "glepnir/lspsaga.nvim", after = "nvim-lspconfig", config = conf.lspsaga })

plugin({ "quarto-dev/quarto-nvim", after = "nvim-lspconfig", config = conf.quarto })

plugin({
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  config = conf.nvim_cmp,
  requires = {
    { "hrsh7th/cmp-nvim-lsp", after = "nvim-lspconfig" },
    { "hrsh7th/cmp-path", after = "nvim-cmp" },
    { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
    { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
  },
})

plugin({ "L3MON4D3/LuaSnip", event = "InsertCharPre", config = conf.lua_snip })

plugin({ "windwp/nvim-autopairs", event = "InsertEnter", config = conf.auto_pairs })
