-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local config = {}

function config.telescope()
  if not packer_plugins["plenary.nvim"].loaded then
    vim.cmd([[packadd plenary.nvim]])
    vim.cmd([[packadd telescope-fzy-native.nvim]])
    vim.cmd([[packadd telescope-file-browser.nvim]])
  end
  local fb_actions = require("telescope").extensions.file_browser.actions
  require("telescope").setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      layout_config = {
        horizontal = { prompt_position = "top", results_width = 0.6 },
        vertical = { mirror = false },
      },
      sorting_strategy = "ascending",
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
      file_browser = {
        mappings = {
          ["n"] = {
            ["c"] = fb_actions.create,
            ["r"] = fb_actions.rename,
            ["d"] = fb_actions.remove,
            ["o"] = fb_actions.open,
            ["u"] = fb_actions.goto_parent_dir,
          },
        },
      },
    },
  })
  require("telescope").load_extension("fzy_native")
  require("telescope").load_extension("file_browser")
end

function config.nvim_treesitter()
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

  local ignored = {
    "phpdoc",
    "arduino",
    "beancount",
    "bibtex",
    "bluprint",
    "eex",
    "ecma",
    "elvish",
    "embedded_template",
    "vala",
    "wgsl",
    "verilog",
    "twig",
    "turtle",
    "m68k",
    "hocon",
    "lalrpop",
    "ledger",
    "meson",
    "mehir",
    "rasi",
    "rego",
    "racket",
    "pug",
    "java",
    "tlaplus",
    "supercollider",
    "slint",
    "sparql",
    "rst",
    "rnoweb",
    "m68k",
  }

  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    ignore_install = ignored,
    highlight = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },
  })
end

function config.trouble()
  require("trouble").setup({})
end

function config.todo_comments()
  require("todo-comments").setup({})
end

function config.dap()
  require("dapui").setup({
    --
  })
end

-- wait for PR from jmbuhr
-- function config.femaco()
--   require("femaco").setup({
--     -- config
--   })
-- end

return config
