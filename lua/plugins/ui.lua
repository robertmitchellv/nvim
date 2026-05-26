-- icons
local icons = require("utils.icons")

-- plugins
return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm",
      terminal_colors = true,
      transparent = true,
      styles = {
        keywords = { bold = true },
        functions = { bold = true },
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        colors.bg_statusline = colors.none
      end,
      on_highlights = function(hl, c)
        hl.StatusLine = { bg = "NONE" }
        hl.StatusLineNC = { bg = "NONE" }
      end,
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
          with_expanders = true,
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
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local b = icons.bubbles
      local colors = require("tokyonight.colors").setup()

      -- ──────────────────────────────────────────────────────────
      -- three-tier diverging layout
      --
      -- LEFT:  [tier1: mode] [tier2: branch] [tier2: file] [tier3: diff] [tier3: navic]  ← center
      -- RIGHT: center →  [tier3: noice] [tier3: dap] [tier2: diag] [tier2: lsp] [tier1: arch]
      --
      -- tier 1: bright bg, dark text (vivid bookends)
      -- tier 2: medium-dark bg, colored text (readable, present)
      -- tier 3: darkest bg, colored text (fades toward center)
      -- ──────────────────────────────────────────────────────────

      -- mode → bookend color (tier 1 background)
      local mode_accent = {
        n = b.red,
        no = b.red,
        i = b.green,
        v = b.magenta,
        [""] = b.magenta,
        V = b.magenta,
        s = b.orange,
        S = b.orange,
        [""] = b.orange,
        R = b.red,
        Rv = b.red,
        c = b.cyan,
        cv = b.cyan,
        ce = b.cyan,
        ["!"] = b.cyan,
        ic = b.cyan_lt,
        r = b.cyan_lt,
        rm = b.cyan_lt,
        ["r?"] = b.cyan_lt,
        t = b.cyan_lt,
      }

      -- mode → icon
      local mode_icon = {
        n = icons.lualine.neovim_icon,
        no = icons.lualine.neovim_icon,
        i = icons.lualine.change,
        v = icons.lualine.select,
        [""] = icons.lualine.select,
        V = icons.lualine.select,
        s = icons.lualine.select,
        S = icons.lualine.select,
        [""] = icons.lualine.select,
        R = icons.lualine.replace,
        Rv = icons.lualine.replace,
        c = icons.lualine.terminal,
        cv = icons.lualine.terminal,
        ce = icons.lualine.terminal,
        ["!"] = icons.lualine.terminal,
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
          component_separators = "",
          section_separators = "",
          theme = {
            normal = { c = { fg = colors.fg, bg = "NONE" } },
            inactive = { c = { fg = colors.fg, bg = "NONE" } },
          },
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
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
      }

      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end
      local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
      end

      -- ════════════════════════════════════════════════════════════
      -- LEFT SIDE
      -- ════════════════════════════════════════════════════════════

      -- ── TIER 1: mode (bright bookend) ───────────────────────
      ins_left({
        function()
          return icons.lualine.bubble_left
        end,
        color = function()
          return { fg = mode_accent[vim.fn.mode()] or b.red, bg = "NONE" }
        end,
        padding = { left = 0, right = 0 },
      })
      ins_left({
        function()
          return mode_icon[vim.fn.mode()] or ""
        end,
        color = function()
          return { fg = b.dark_fg, bg = mode_accent[vim.fn.mode()] or b.red, gui = "bold" }
        end,
        padding = { left = 1, right = 1 },
      })
      ins_left({
        function()
          return icons.lualine.bubble_right
        end,
        color = function()
          return { fg = mode_accent[vim.fn.mode()] or b.red, bg = "NONE" }
        end,
        padding = { left = 0, right = 1 },
      })

      -- ── TIER 2: branch (medium-dark, colored text) ──────────
      ins_left({
        function()
          return icons.lualine.bubble_left
        end,
        color = { fg = b.tier2_bg, bg = "NONE" },
        padding = { left = 0, right = 0 },
        cond = conditions.check_git_workspace,
      })
      ins_left({
        "branch",
        icon = icons.lualine.branch,
        color = { fg = b.magenta, bg = b.tier2_bg, gui = "bold" },
        padding = { left = 1, right = 1 },
        cond = conditions.check_git_workspace,
      })
      ins_left({
        function()
          return icons.lualine.bubble_right
        end,
        color = { fg = b.tier2_bg, bg = "NONE" },
        padding = { left = 0, right = 1 },
        cond = conditions.check_git_workspace,
      })

      -- ── TIER 2: file (medium-dark, light text) ─────────────
      ins_left({
        function()
          return icons.lualine.bubble_left
        end,
        color = { fg = b.tier2_bg, bg = "NONE" },
        padding = { left = 0, right = 0 },
        cond = conditions.buffer_not_empty,
      })
      ins_left({
        "filetype",
        icon_only = true,
        color = { bg = b.tier2_bg },
        padding = { left = 1, right = 0 },
        cond = conditions.buffer_not_empty,
      })
      ins_left({
        "filename",
        path = 0,
        symbols = {
          modified = icons.lualine.modified,
          readonly = icons.lualine.readonly,
          unnamed = "",
        },
        color = { fg = b.light_fg, bg = b.tier2_bg, gui = "italic" },
        padding = { left = 1, right = 1 },
        cond = conditions.buffer_not_empty,
      })
      ins_left({
        function()
          return icons.lualine.bubble_right
        end,
        color = { fg = b.tier2_bg, bg = "NONE" },
        padding = { left = 0, right = 1 },
        cond = conditions.buffer_not_empty,
      })

      -- ── TIER 3: diff (darkest, semantic colors) ─────────────
      ins_left({
        function()
          return icons.lualine.bubble_left
        end,
        color = { fg = b.tier3_bg, bg = "NONE" },
        padding = { left = 0, right = 0 },
        cond = conditions.hide_in_width,
      })
      ins_left({
        "diff",
        symbols = {
          added = icons.lualine.add,
          modified = icons.lualine.change,
          removed = icons.lualine.delete,
        },
        diff_color = {
          added = { fg = b.green, bg = b.tier3_bg },
          modified = { fg = b.cyan, bg = b.tier3_bg },
          removed = { fg = b.red, bg = b.tier3_bg },
        },
        cond = conditions.hide_in_width,
        padding = { left = 1, right = 1 },
      })
      ins_left({
        function()
          return icons.lualine.bubble_right
        end,
        color = { fg = b.tier3_bg, bg = "NONE" },
        padding = { left = 0, right = 1 },
        cond = conditions.hide_in_width,
      })

      -- ── TIER 3: navic breadcrumbs (darkest) ─────────────────
      ins_left({
        function()
          return icons.lualine.bubble_left
        end,
        color = { fg = b.tier3_bg, bg = "NONE" },
        padding = { left = 0, right = 0 },
        cond = function()
          return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
        end,
      })
      ins_left({
        function()
          return require("nvim-navic").get_location()
        end,
        color = { fg = b.light_fg, bg = b.tier3_bg },
        padding = { left = 1, right = 1 },
        cond = function()
          return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
        end,
      })
      ins_left({
        function()
          return icons.lualine.bubble_right
        end,
        color = { fg = b.tier3_bg, bg = "NONE" },
        padding = { left = 0, right = 0 },
        cond = function()
          return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
        end,
      })

      -- ════════════════════════════════════════════════════════════
      -- RIGHT SIDE
      -- ════════════════════════════════════════════════════════════

      -- ── TIER 3: noice mode (darkest, inner) ─────────────────
      ins_right({
        function()
          return icons.lualine.bubble_left
        end,
        color = { fg = b.tier3_bg, bg = "NONE" },
        padding = { left = 0, right = 0 },
        cond = function()
          return package.loaded["noice"] and require("noice").api.status.mode.has()
        end,
      })
      ins_right({
        function()
          return require("noice").api.status.mode.get()
        end,
        color = { fg = b.orange, bg = b.tier3_bg },
        padding = { left = 1, right = 1 },
        cond = function()
          return package.loaded["noice"] and require("noice").api.status.mode.has()
        end,
      })
      ins_right({
        function()
          return icons.lualine.bubble_right
        end,
        color = { fg = b.tier3_bg, bg = "NONE" },
        padding = { left = 0, right = 1 },
        cond = function()
          return package.loaded["noice"] and require("noice").api.status.mode.has()
        end,
      })

      -- ── TIER 3: dap status (darkest, inner) ─────────────────
      ins_right({
        function()
          return icons.lualine.bubble_left
        end,
        color = { fg = b.tier3_bg, bg = "NONE" },
        padding = { left = 0, right = 0 },
        cond = function()
          return package.loaded["dap"] and require("dap").status() ~= ""
        end,
      })
      ins_right({
        function()
          return icons.lualine.error .. require("dap").status()
        end,
        color = { fg = b.red, bg = b.tier3_bg },
        padding = { left = 1, right = 1 },
        cond = function()
          return package.loaded["dap"] and require("dap").status() ~= ""
        end,
      })
      ins_right({
        function()
          return icons.lualine.bubble_right
        end,
        color = { fg = b.tier3_bg, bg = "NONE" },
        padding = { left = 0, right = 1 },
        cond = function()
          return package.loaded["dap"] and require("dap").status() ~= ""
        end,
      })

      -- ── TIER 2: diagnostics (medium-dark, semantic colors) ──
      ins_right({
        function()
          return icons.lualine.bubble_left
        end,
        color = { fg = b.tier2_bg, bg = "NONE" },
        padding = { left = 0, right = 0 },
      })
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
          error = { fg = b.red, bg = b.tier2_bg },
          warn = { fg = b.orange, bg = b.tier2_bg },
          info = { fg = b.cyan, bg = b.tier2_bg },
          hint = { fg = b.green, bg = b.tier2_bg },
        },
        padding = { left = 1, right = 1 },
      })
      ins_right({
        function()
          return icons.lualine.bubble_right
        end,
        color = { fg = b.tier2_bg, bg = "NONE" },
        padding = { left = 0, right = 1 },
      })

      -- ── TIER 2: lsp server name (medium-dark, colored) ──────
      ins_right({
        function()
          return icons.lualine.bubble_left
        end,
        color = { fg = b.tier2_bg, bg = "NONE" },
        padding = { left = 0, right = 0 },
      })
      ins_right({
        function()
          local msg = "no active lsp"
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            return msg
          end
          local buf_ft = vim.bo[0].filetype
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        icon = icons.lualine.lsp_icon,
        color = { fg = b.magenta, bg = b.tier2_bg, gui = "bold" },
        padding = { left = 1, right = 1 },
      })
      ins_right({
        function()
          return icons.lualine.bubble_right
        end,
        color = { fg = b.tier2_bg, bg = "NONE" },
        padding = { left = 0, right = 1 },
      })

      -- ── TIER 1: arch logo (bright bookend) ──────────────────
      ins_right({
        function()
          return icons.lualine.bubble_left
        end,
        color = function()
          return { fg = mode_accent[vim.fn.mode()] or b.red, bg = "NONE" }
        end,
        padding = { left = 0, right = 0 },
      })
      ins_right({
        function()
          return icons.lualine.status_right_arch
        end,
        color = function()
          return { fg = b.dark_fg, bg = mode_accent[vim.fn.mode()] or b.red, gui = "bold" }
        end,
        padding = { left = 1, right = 1 },
      })
      ins_right({
        function()
          return icons.lualine.bubble_right
        end,
        color = function()
          return { fg = mode_accent[vim.fn.mode()] or b.red, bg = "NONE" }
        end,
        padding = { left = 0, right = 0 },
      })

      return config
    end,
  },
}
