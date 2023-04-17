local package = require("core.pack").package
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

package({
  "williamboman/mason.nvim",
  config = conf.mason,
})

package({
  "williamboman/mason-lspconfig.nvim",
  config = conf.mason_lspconfig,
})

package({
  "neovim/nvim-lspconfig",
  -- used filetype to lazyload lsp
  -- config your language filetype in here
  ft = enable_lsp_filetype,
  config = conf.nvim_lsp,
})

package({
  "glepnir/lspsaga.nvim",
  event = "BufRead",
  ft = enable_lsp_filetype,
  config = conf.lspsaga,
})

package({
  "quarto-dev/quarto-nvim",
  config = conf.quarto,
  dependencies = {
    { "jmbuhr/otter.nvim" },
    { "neovim/nvim-lspconfig" },
  },
})

package({
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  config = conf.nvim_cmp,
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-buffer" },
    { "saadparwaiz1/cmp_luasnip" },
  },
})

package({ "L3MON4D3/LuaSnip", event = "InsertCharPre", config = conf.lua_snip })

package({ "windwp/nvim-autopairs", event = "InsertEnter", config = conf.auto_pairs })
