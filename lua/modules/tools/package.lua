local package = require("core.pack").package
local conf = require("modules.tools.config")

package({
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  config = conf.telescope,
  dependencies = {
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzy-native.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },
  },
})

package({
  "nvim-treesitter/nvim-treesitter",
  event = "BufRead",
  run = ":TSUpdate",
  after = "telescope.nvim",
  config = conf.nvim_treesitter,
})

package({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })

package({ "p00f/nvim-ts-rainbow", after = "nvim-treesitter" })

package({
  "folke/trouble.nvim",
  config = conf.trouble,
  dependencies = { "nvim-tree/nvim-web-devicons" },
})

package({
  "folke/todo-comments.nvim",
  config = conf.todo_comments,
  dependencies = { "nvim-lua/plenary.nvim" },
})

package({
  "rcarriga/nvim-dap-ui",
  config = conf.dap,
  dependencies = { "mfussenegger/nvim-dap" }
})

package({
  "nvimdev/nerdicons.nvim",
  config = conf.nerdicons,
})
-- wait for PR from jmbuhr
-- package({
--   "AckslD/nvim-FeMaco.lua",
--   config = conf.femaco,
--   dependencies = { "nvim-treesitter" },
-- })
