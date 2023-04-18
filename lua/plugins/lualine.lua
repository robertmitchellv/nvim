return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local icons = {
      left_bar = "▊ ",
      right_bar = " ▊",
      left_bubble = "",
      right_bubble = "",
      status_left = " ",
      branch = " ",
      add = "  ",
      change = "  ",
      delete = "  ",
      lsp_icon = "lsp  ",
      error = "  ",
      warn = "  ",
      hint = "  ",
      info = "  ",
      status_right = " ",
    }
    local colors = require("tokyonight.colors").setup()
    local util = require("tokyonight.util")
    colors.lualine = {}
    colors.lualine.branch_bg = util.blend(colors.purple, colors.bg, 0.5)
    colors.lualine.branch_fg = util.blend(colors.fg, colors.lualine.branch_bg, 0.8)
    colors.lualine.add_bg = util.blend(colors.git.add, colors.bg, 0.5)
    colors.lualine.add_fg = util.blend(colors.fg, colors.lualine.add_bg, 0.8)
    colors.lualine.change_bg = util.blend(colors.git.change, colors.bg, 0.5)
    colors.lualine.change_fg = util.blend(colors.fg, colors.lualine.change_bg, 0.8)
    colors.lualine.delete_bg = util.blend(colors.git.delete, colors.bg, 0.5)
    colors.lualine.delete_fg = util.blend(colors.fg, colors.lualine.delete_bg, 0.8)
    colors.lualine.lsp_icon_bg = util.blend(colors.comment, colors.bg, 0.8)
    colors.lualine.lsp_icon_fg = util.blend(colors.fg, colors.lualine.lsp_icon_bg, 0.8)
    colors.lualine.error_bg = util.blend(colors.error, colors.bg, 0.5)
    colors.lualine.error_fg = util.blend(colors.fg, colors.lualine.error_bg, 0.8)
    colors.lualine.warn_bg = util.blend(colors.warning, colors.bg, 0.5)
    colors.lualine.warn_fg = util.blend(colors.fg, colors.lualine.warn_bg, 0.8)
    colors.lualine.hint_bg = util.blend(colors.hint, colors.bg, 0.5)
    colors.lualine.hint_fg = util.blend(colors.fg, colors.lualine.hint_bg, 0.8)
    colors.lualine.info_bg = util.blend(colors.info, colors.bg, 0.5)
    colors.lualine.info_fg = util.blend(colors.fg, colors.lualine.info_bg, 0.8)
    colors.lualine.encoding_bg = util.blend(colors.blue, colors.bg, 0.5)
    colors.lualine.encoding_fg = util.blend(colors.fg, colors.lualine.encoding_bg, 0.8)
    colors.lualine.format_bg = util.blend(colors.blue, colors.bg, 0.8)
    colors.lualine.format_fg = util.blend(colors.fg, colors.lualine.format_bg, 0.8)
    local mode_color = {
      -- normal
      n = colors.blue,
      no = colors.blue,
      -- insert
      i = colors.green,
      -- visual
      v = colors.magenta,
      [""] = colors.magenta,
      V = colors.magenta,
      -- select
      s = colors.orange,
      S = colors.orange,
      [""] = colors.orange,
      -- replace
      R = colors.red,
      Rv = colors.red,
      -- command
      c = colors.yellow,
      cv = colors.yellow,
      ce = colors.yellow,
      ["!"] = colors.yellow,
      -- other
      ic = colors.teal,
      r = colors.teal,
      rm = colors.teal,
      ["r?"] = colors.teal,
      t = colors.teal,
    }
    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    -- Config
    local config = {
      options = {
        -- Disable sections and component separators
        component_separators = "",
        section_separators = { right = icons.right_bubble },
        theme = {
          normal = { c = { fg = colors.fg, bg = colors.bg } },
          inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x at right section
    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    ins_left({
      function()
        return icons.left_bar
      end,
      color = function()
        return { fg = mode_color[vim.fn.mode()] }
      end,
      padding = { left = 0, right = 1 }, -- We don"t need space before this
    })

    ins_left({
      -- mode component
      function()
        return icons.status_left
      end,
      color = function()
        return { fg = mode_color[vim.fn.mode()] }
      end,
      padding = { right = 1 },
    })

    ins_left({
      "branch",
      icon = icons.branch,
      color = {
        fg = colors.lualine.branch_fg,
        bg = colors.lualine.branch_bg,
        gui = "bold",
      },
      separator = {
        left = icons.left_bubble,
        right = icons.right_bubble,
      },
    })

    ins_left({
      "diff",
      draw_empty = true,
      symbols = {
        added = icons.add,
        modified = icons.change,
        removed = icons.delete,
      },
      diff_color = {
        added = { fg = colors.lualine.add_fg, bg = colors.lualine.add_bg },
        modified = { fg = colors.lualine.change_fg, bg = colors.lualine.change_bg },
        removed = { fg = colors.lualine.delete_fg, bg = colors.lualine.delete_bg },
      },
      separator = { right = icons.right_bubble },
      cond = conditions.hide_in_width,
    })

    -- ins_left({
    --   "filename",
    --   cond = conditions.buffer_not_empty,
    --   color = { fg = colors.magenta, gui = "bold" },
    -- })

    -- ins_left({ "location" })

    -- ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it"s any number greater then 2
    ins_left({
      function()
        return "%="
      end,
    })

    ins_left({
      -- Lsp server name .
      function()
        local msg = "No Active Lsp"
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
          return msg
        end
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
          end
        end
        return msg
      end,
      icon = icons.lsp_icon,
      color = {
        fg = colors.lualine.lsp_icon_fg,
        bg = colors.lualine.lsp_icon_bg,
        gui = "bold",
      },
      separator = { left = icons.left_bubble, right = icons.right_bubble },
    })

    ins_right({
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = {
        error = icons.error,
        warn = icons.warn,
        info = icons.info,
        hint = icons.hint,
      },
      diagnostics_color = {
        error = {
          fg = colors.lualine.error_fg,
          bg = colors.lualine.error_bg,
        },
        warn = {
          fg = colors.lualine.warn_fg,
          bg = colors.lualine.warn_bg,
        },
        info = {
          fg = colors.lualine.info_fg,
          bg = colors.lualine.info_bg,
        },
        hint = {
          fg = colors.lualine.hint_fg,
          bg = colors.lualine.hint_bg,
        },
        separator = { right = icons.left_bubble },
      },
    })

    -- Add components to right sections
    ins_right({
      "o:encoding", -- option component same as &encoding in viml
      fmt = string.upper, -- I"m not sure why it"s upper case either ;)
      cond = conditions.hide_in_width,
      color = { fg = colors.green, gui = "bold" },
    })

    ins_right({
      "fileformat",
      fmt = string.upper,
      icons_enabled = true, -- I think icons are cool but Eviline doesn"t have them. sigh
      color = { fg = colors.green, gui = "bold" },
    })

    ins_right({
      function()
        return icons.status_right
      end,
      color = function()
        return { fg = mode_color[vim.fn.mode()] }
      end,
      padding = { left = 2, right = 0 },
    })

    ins_right({
      function()
        return icons.left_bar
      end,
      color = function()
        return { fg = mode_color[vim.fn.mode()] }
      end,
      padding = { left = 1 },
    })
    return config
  end,
}
