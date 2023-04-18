local config = {}

function config.mason()
  local mason = require("mason")
  mason.setup()
end

function config.mason_lspconfig()
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({
    ensure_installed = {
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
      "lua_ls",
      "marksman", -- markdown
      "pyright",
      "r_language_server",
      "rust_analyzer",
      "sqlls",
      "taplo", -- toml
      "tailwindcss",
      "terraformls",
      "tsserver", -- ts and js
      "volar", -- vue
      "yamlls",
    },
  })
end

-- config server in this function
function config.nvim_lsp()
  require("modules.completion.lspconfig")
end

function config.lspsaga()
  require("lspsaga").setup({})
end

function config.quarto()
  require("quarto").setup({
    lspFeatures = {
      enabled = true,
      languages = { "r", "python", "julia" },
      diagnostics = {
        enabled = true,
        triggers = { "BufWrite" }
      },
      completion = {
        enabled = true
      }
    }
  })
end

function config.nvim_cmp()
  local cmp = require("cmp")

  cmp.setup({
    preselect = cmp.PreselectMode.Item,
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    formatting = {
      fields = { "abbr", "kind", "menu" },
    },
    -- You can set mappings if you want
    mapping = cmp.mapping.preset.insert({
      ["<C-e>"] = cmp.config.disable,
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
      { name = "buffer" },
    },
  })
end

function config.lua_snip()
  local ls = require("luasnip")
  local types = require("luasnip.util.types")
  ls.config.set_config({
    history = true,
    enable_autosnippets = true,
    updateevents = "TextChanged,TextChangedI",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "<- choiceNode", "Comment" } },
        },
      },
    },
  })
  require("luasnip.loaders.from_lua").lazy_load({
    paths = vim.fn.stdpath("config") .. "/snippets",
  })
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load({
    paths = { "./snippets/" },
  })
end

function config.auto_pairs()
  require("nvim-autopairs").setup({})
  local status, cmp = pcall(require, "cmp")
  if not status then
    vim.cmd([[packadd nvim-cmp]])
    cmp = require("cmp")
  end
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({
    map_char = { tex = "" }
  }))
end

return config
