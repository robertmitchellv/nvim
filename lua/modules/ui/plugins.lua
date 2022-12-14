-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local plugin = require("core.pack").register_plugin
local conf = require("modules.ui.config")

plugin({ "folke/tokyonight.nvim", config = conf.tokyonight })

plugin({ "glepnir/dashboard-nvim", config = conf.dashboard })

-- require devicons here
plugin({
  "nvim-tree/nvim-tree.lua",
  config = conf.nvim_tree,
  requires = { "nvim-tree/nvim-web-devicons" },
  tag = "nightly",
})

-- use wants devicons below
plugin({
  "glepnir/galaxyline.nvim",
  branch = "main",
  config = conf.galaxyline,
  wants = "nvim-tree/nvim-web-devicons",
})

plugin({
  "romgrk/barbar.nvim",
  config = conf.barbar,
  wants = "nvim-web-devicons"
})

plugin({
  "lewis6991/gitsigns.nvim",
  config = conf.gitsigns,
  requires = { "nvim-lua/plenary.nvim" },
})

plugin({
  "kevinhwang91/nvim-hlslens",
  config = conf.hlslens,
})

plugin({
  "petertriho/nvim-scrollbar",
  config = conf.scrollbar,
  wants = {
    "gitsigns",
    "hlslens"
  }
})

plugin({
  "folke/noice.nvim",
  config = conf.noice,
  requires = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  }
})
