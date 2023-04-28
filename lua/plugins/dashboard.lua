return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    local dashboard = require("dashboard")
    local icons = {
      lazy = "󰒲 ",
      update = " ",
      sync = " ",
      mason = "  ",
      telescope = "  ",
    }
    dashboard.setup({
      theme = "hyper",
      config = {
        week_header = {
          -- to turn off pass false here
          enable = true,
        },
        shortcut = {
          {
            desc = icons.lazy .. "lazy",
            action = "Lazy",
            key = "l",
          },
          {
            desc = icons.lazy .. icons.sync .. "sync",
            action = "Lazy sync",
            key = "s",
          },
          {
            desc = icons.mason .. "mason",
            action = "Mason",
            key = "m",
          },
          {
            desc = icons.telescope .. "find file",
            -- desc_hl = { fg = colors.green },
            -- group = "Telescope",
            action = "Telescope find_files",
            key = "f",
          },
        },
        project = { limit = 5, icon = " " },
        mru = { limit = 5, icon = " " },
      },
    })
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
