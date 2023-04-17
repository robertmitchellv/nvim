return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  enabled = false,
  opts = function()
    local icons = {
      left_bar = "▊ ",
      right_bar = " ▊",
      left_bubble = "",
      right_bubble = "",
      status_left = "  ",
      git = "    ",
      branch = "   ",
      add = "  ",
      change = "  ",
      delete = "  ",
      lsp_icon = "  lsp   ",
      error = "  ",
      warn = "  ",
      hint = "  ",
      info = "  ",
      status_right = "  ",
    }
    local function fg(name)
      return function()
        ---@type {foreground?:number}?
        local hl = vim.api.nvim_get_hl_by_name(name, true)
        return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
      end
    end

    return {
      options = {
        theme = "auto",
        component_separators = { left = icons.left_bubble, right = icons.right_bubble },
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
      sections = {
        lualine_a = {
          "mode",
        },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.error,
              warn = icons.warn,
              info = icons.info,
              hint = icons.hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          -- stylua: ignore
          {
            function() return require("nvim-navic").get_location() end,
            cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
          },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = fg("Statement")
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = fg("Constant") ,
          },
          { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
          {
            "diff",
            symbols = {
              added = icons.add,
              modified = icons.change,
              removed = icons.delete,
            },
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
