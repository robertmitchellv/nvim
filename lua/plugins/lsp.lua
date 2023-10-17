return {
  -- this is for DAPs, linters, and formatters
  -- LSP goes in the next section
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "ansible-lint",
        "beautysh",
        "black",
        "curlylint",
        "docformatter",
        "fixjson",
        "flake8",
        "gh",
        "gitlint",
        "jq",
        "luacheck",
        "luaformatter",
        "nginx-language-server",
        "prettier",
        "ruff",
        "rustfmt",
        "rustywind",
        "shellcheck",
        "stylua",
        "write-good",
        "xmlformatter",
        "yamllint",
        "yq",
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
        astro = {},
        bashls = {},
        clangd = {},
        cmake = {},
        cssls = {},
        denols = {},
        docker_compose_lang = {},
        dockerls = {},
        gopls = {},
        grammarly = {},
        helm_ls = {},
        html = {},
        jsonls = {},
        julials = {},
        lemminx = {},
        ltex = {},
        lua_ls = {},
        marksman = {},
        ruff_lsp = {},
        rust_analyzer = {},
        spectral = {},
        sqlls = {},
        tailwindcss = {},
        taplo = {},
        terraformls = {},
        tsserver = {},
        vimls = {},
        volar = {},
        yamlls = {},
        zls = {},
      },
      setup = {},
    },
  },

  -- lspsaga; not sure if i'll use it or not
  -- {
  --   "nvimdev/lspsaga.nvim",
  --   config = function()
  --     require("lspsaga").setup({
  --       -- add your config value here
  --     })
  --   end,
  -- },
}
