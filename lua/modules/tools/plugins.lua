-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require("core.pack").register_plugin
local conf = require("modules.tools.config")

plugin({
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  config = conf.telescope,
  requires = {
    { "nvim-lua/popup.nvim", opt = true },
    { "nvim-lua/plenary.nvim", opt = true },
    { "nvim-telescope/telescope-fzy-native.nvim", opt = true },
    { "nvim-telescope/telescope-file-browser.nvim", opt = true },
  },
})

plugin({
  "nvim-treesitter/nvim-treesitter",
  event = "BufRead",
  run = ":TSUpdate",
  after = "telescope.nvim",
  config = conf.nvim_treesitter,
})

plugin({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })

plugin({
  "folke/trouble.nvim",
  config = conf.trouble,
  requires = { "nvim-tree/nvim-web-devicons" },
})

plugin({
  "folke/todo-comments.nvim",
  config = conf.todo_comments,
  requires = { "nvim-lua/plenary.nvim" },
})
