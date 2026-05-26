-- hyper-themed dashboard with a small set of shortcuts
-- * snacks dashboard is disabled in snacks.lua in favor of this one

local icons = require("utils.icons")

return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("dashboard").setup({
      theme = "hyper",
      config = {
        week_header = { enable = true },
        shortcut = {
          {
            desc = icons.dashboard.lazy .. "lazy",
            action = "Lazy",
            key = "l",
          },
          {
            desc = icons.dashboard.sync .. "sync",
            action = "Lazy sync",
            key = "s",
          },
          {
            desc = icons.dashboard.mason .. "mason",
            action = "Mason",
            key = "m",
          },
          {
            desc = icons.dashboard.telescope .. "find file",
            action = "Telescope find_files",
            key = "f",
          },
          {
            desc = icons.dashboard.exit .. "exit",
            action = ":q!",
            key = "q",
          },
        },
        project = { limit = 5, icon = icons.dashboard.project },
        mru = { limit = 5, icon = icons.dashboard.mru },
      },
    })
  end,
}
