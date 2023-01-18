local package = require("core.pack").package
local conf = require("modules.ui.config")

package({ "folke/tokyonight.nvim", config = conf.tokyonight })

package({ "glepnir/dashboard-nvim", config = conf.dashboard })

package({
  "nvim-tree/nvim-tree.lua",
  config = conf.nvim_tree,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  tag = "nightly",
})

package({
  "glepnir/galaxyline.nvim",
  branch = "main",
  config = conf.galaxyline,
  dependencies = { "nvim-tree/nvim-web-devicons" },
})

package({
  "romgrk/barbar.nvim",
  config = conf.barbar,
  dependencies = { "nvim-tree/nvim-web-devicons" },
})

package({
  "lewis6991/gitsigns.nvim",
  config = conf.gitsigns,
  dependencies = { "nvim-lua/plenary.nvim" },
})

package({
  "kevinhwang91/nvim-hlslens",
  config = conf.hlslens,
})

package({
  "petertriho/nvim-scrollbar",
  config = conf.scrollbar, 
})

package({
  "folke/noice.nvim",
  config = conf.noice,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  }
})
