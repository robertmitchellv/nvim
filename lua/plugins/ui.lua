-- icons
local icons = {
  dashboard = {
      lazy = "󰒲 ",
      update = " ",
      sync = " ",
      mason = "  ",
      telescope = "  ",
      exit = " ",
  },
  lualine = {
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
    status_right_pop = " ",
    status_right_mac = " ",
    copilot = require("lazyvim.config").icons.kinds.Copilot,
  },
  neotree = {
    default = " ",
    symlink = " ",
    bookmark = " ",
    folder = {
      arrow_closed = " ",
      arrow_open = " ",
      default = " ",
      open = " ",
      empty = " ",
      closed = " ",
      empty_open = " ",
      symlink = " ",
      symlink_open = " ",
      symlink_arrow = "  ",
    },
    file = {
      modified = "󱇨 ",
    },
    git = {
      unstaged = " ",
      staged = " ",
      unmerged = " ",
      renamed = " ",
      untracked = " ",
      deleted = " ",
      ignored = " ",
      conflict = "裂",
    },
  }
}

-- plugins
return {

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      local dashboard = require("dashboard")
      dashboard.setup({
        theme = "hyper",
        config = {
          week_header = {
            -- to turn off pass false here
            enable = true,
          },
          shortcut = {
            {
              desc = icons.dashboard.lazy .. "lazy",
              action = "Lazy",
              key = "l",
            },
            {
              desc = icons.dashboard.lazy .. icons.sync .. "sync",
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
              -- desc_hl = { fg = colors.green },
              -- group = "Telescope",
              action = "Telescope find_files",
              key = "f",
            },
            {
              desc = icons.dashboard.exit .. "exit",
              action = ":q!",
              key = "q",
            },
          },
          project = { limit = 5, icon = " " },
          mru = { limit = 5, icon = " " },
        },
      })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local Util = require("lazyvim.util")
      local colors = require("tokyonight.colors").setup()
      local copilot_colors = {
        [""] = Util.fg("Special"),
        ["Normal"] = Util.fg("Special"),
        ["Warning"] = Util.fg("DiagnosticError"),
        ["InProgress"] = Util.fg("DiagnosticWarn"),
      }
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
        n = icons.lualine.status_left,
        no = icons.lualine.status_left,
        -- insert
        i = icons.lualine.change,
        -- visual
        v = icons.lualine.select,
        [""] = icons.lualine.select,
        V = icons.lualine.select,
        -- select
        s = icons.lualine.select,
        S = icons.lualine.select,
        [""] = icons.lualine.select,
        -- replace
        R = icons.lualine.replace,
        Rv = icons.lualine.replace,
        -- command
        c = icons.lualine.terminal,
        cv = icons.lualine.terminal,
        ce = icons.lualine.terminal,
        ["!"] = icons.lualine.terminal,
        -- other
        ic = icons.lualine.status_left,
        r = icons.lualine.status_left,
        rm = icons.lualine.status_left,
        ["r?"] = icons.lualine.status_left,
        t = icons.lualine.status_left,
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
              "mason",
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
          return icons.lualine.left_bar
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
        icon = icons.lualine.branch,
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
          added = icons.lualine.add,
          modified = icons.lualine.change,
          removed = icons.lualine.delete,
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
          return icons.lualine.error .. require("dap").status()
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
          error = icons.lualine.error,
          warn = icons.lualine.warn,
          info = icons.lualine.info,
          hint = icons.lualine.hint,
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
        icon = icons.lualine.lsp_icon,
        color = { fg = colors.magenta, gui = "bold" },
        padding = { left = 1, right = 2 },
      })

      ins_right({
        function()
          local status = require("copilot.api").status.data
          return icons.lualine.copilot .. (status.message or "")
        end,
        cond = function()
          local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
          return ok and #clients > 0
        end,
        color = function()
          local status = require("copilot.api").status.data
          return copilot_colors[status.status] or copilot_colors[""]
        end,
        padding = { left = 1, right = 1 },
      })

      -- os logo
      ins_right({
        function()
          return icons.lualine.status_right_pop
        end,
        color = function()
          return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { left = 1, right = 0 },
      })

      -- right bar; color change with vim mode
      ins_right({
        function()
          return icons.lualine.right_bar
        end,
        color = function()
          return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { left = 1, right = 0 },
      })
      return config
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
        never_show = {
          ".DS_Store",
        },
      },
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = icons.neotree.folder.arrow_closed,
          expander_expanded = icons.neotree.folder.arrow_open,
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = icons.neotree.folder.default,
          folder_open = icons.neotree.folder.open,
          folder_empty = icons.neotree.folder.empty,
          default = icons.neotree.folder.default,
        },
        modified = {
          symbol = icons.neotree.file.modified,
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = icons.neotree.git.deleted,
            untracked = icons.neotree.git.untracked,
            ignored = icons.neotree.git.ignored,
            unstaged = icons.neotree.git.unstaged,
            staged = icons.neotree.git.staged,
            conflict = icons.neotree.git.conflict,
          },
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },

  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      background_colour = function()
        local colors require("tokyonight.colors").setup()
        return colors.bg
      end,
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local Util = require("lazyvim.util")
      if not Util.has("noice.nvim") then
        Util.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
