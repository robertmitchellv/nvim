return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local Util = require("lazyvim.util")
    local icons = {
      left_bar = "▊ ",
      right_bar = " ▊",
      status_left = " ",
      branch = "",
      add = " ",
      change = " ",
      delete = " ",
      lsp_icon = "lsp  ",
      error = " ",
      warn = " ",
      hint = " ",
      info = " ",
      select = " ",
      terminal = " ",
      replace = " ",
      status_right = " ",
    }
    local colors = require("tokyonight.colors").setup()
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
    local mode_icon = {
      -- normal
      n = icons.status_left,
      no = icons.status_left,
      -- insert
      i = icons.change,
      -- visual
      v = icons.select,
      [""] = icons.select,
      V = icons.select,
      -- select
      s = icons.select,
      S = icons.select,
      [""] = icons.select,
      -- replace
      R = icons.replace,
      Rv = icons.replace,
      -- command
      c = icons.terminal,
      cv = icons.terminal,
      ce = icons.terminal,
      ["!"] = icons.terminal,
      -- other
      ic = icons.status_left,
      r = icons.status_left,
      rm = icons.status_left,
      ["r?"] = icons.status_left,
      t = icons.status_left,
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
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = {
          statusline = {
            "dashboard",
            "alpha",
            "neo-tree",
            "lazy",
          },
        },
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
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
      padding = { left = 0, right = 1 },
    })

    ins_left({
      -- mode component
      function()
        return mode_icon[vim.fn.mode()]
      end,
      color = function()
        return { fg = mode_color[vim.fn.mode()] }
      end,
      padding = { left = 0, right = 1 },
    })

    ins_left({
      "branch",
      icon = icons.branch,
      color = { fg = colors.magenta, gui = "bold" },
      padding = { left = 1, right = 1 },
    })

    -- icon for file
    ins_left({
      "filetype",
      icon_only = true,
      padding = { left = 2, right = 1 },
    })

    -- name of file being edited
    ins_left({
      "filename",
      path = 0,
      symbols = { modified = "", readonly = "", unnamed = "" },
      color = { fg = colors.fg, gui = "italic" },
      padding = { left = 0, right = 2 },
    })

    ins_left({
      "diff",
      symbols = {
        added = icons.add,
        modified = icons.change,
        removed = icons.delete,
      },
      diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.blue },
        removed = { fg = colors.red },
      },
      cond = conditions.hide_in_width,
      padding = { left = 2, right = 2 },
    })

    ins_left({
      function()
        return require("nvim-navic").get_location()
      end,
      cond = function()
        return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
      end,
      padding = { left = 2, right = 2 },
    })

    -- right side
    ins_right({
      function()
        return require("noice").api.status.mode.get()
      end,
      cond = function()
        return package.loaded["noice"] and require("noice").api.status.mode.has()
      end,
      color = Util.fg("Constant"),
      padding = { left = 2, right = 2 },
    })

    ins_right({
      function()
        return icons.error .. require("dap").status()
      end,
      cond = function()
        return package.loaded["dap"] and require("dap").status() ~= ""
      end,
      color = Util.fg("Debug"),
      padding = { left = 2, right = 2 },
    })

    -- diagnostics
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
        error = { fg = colors.error },
        warn = { fg = colors.warning },
        info = { fg = colors.info },
        hint = { fg = colors.hint },
      },
      padding = { left = 2, right = 2 },
    })

    ins_right({
      -- Lsp server name .
      function()
        local msg = "no active lsp"
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
      color = { fg = colors.magenta, gui = "bold" },
      padding = { left = 1, right = 2 },
    })

    -- os logo
    ins_right({
      function()
        return icons.status_right
      end,
      color = function()
        return { fg = mode_color[vim.fn.mode()] }
      end,
      padding = { left = 1, right = 0 },
    })

    -- right bar; color change with vim mode
    ins_right({
      function()
        return icons.right_bar
      end,
      color = function()
        return { fg = mode_color[vim.fn.mode()] }
      end,
      padding = { left = 1, right = 0 },
    })
    return config
  end,
}
