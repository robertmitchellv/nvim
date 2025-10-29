-- icons
local icons = require("utils.icons")

-- plugins
return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
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
              desc = icons.dashboard.lazy .. icons.dashboard.sync .. "sync",
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
          project = { limit = 5, icon = icons.dashboard.project },
          mru = { limit = 5, icon = icons.dashboard.mru },
        },
      })
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
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
        n = icons.lualine.neovim_icon,
        no = icons.lualine.neovim_icon,
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
        ic = icons.lualine.neovim_icon,
        r = icons.lualine.neovim_icon,
        rm = icons.lualine.neovim_icon,
        ["r?"] = icons.lualine.neovim_icon,
        t = icons.lualine.neovim_icon,
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
        color = { fg = Snacks.util.color("Constant") },
        padding = { left = 2, right = 2 },
      })

      ins_right({
        function()
          return icons.lualine.error .. require("dap").status()
        end,
        cond = function()
          return package.loaded["dap"] and require("dap").status() ~= ""
        end,
        color = { fg = Snacks.util.color("Debug") },
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

      -- os logo
      ins_right({
        function()
          return icons.lualine.status_right_arch
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
    branch = "v3.x",
    cmd = "Neotree",
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        never_show = { ".DS_Store" },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
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
      local Util = require("lazyvim.util")
      local function on_move(data)
        Util.lsp.on_rename(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
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
    "OXY2DEV/markview.nvim",
    opts = {
      experimental = {
        check_rtp_message = false,
      },
    },
  },
}
