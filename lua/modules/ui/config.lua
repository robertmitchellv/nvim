local config = {}

function config.tokyonight()
  vim.cmd("colorscheme tokyonight")

  local tokyo = require("tokyonight")
  tokyo.setup({
    style = "storm",
    transparent = true,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
      sidebars = "dark",
      floats = "dark",
    }
  })
end

function config.galaxyline()
  require("modules.ui.bubbleline")
end

function config.dashboard()
  local home = os.getenv("HOME")
  local db = require("dashboard")
  local colors = require("tokyonight.colors").setup()
  db.setup({
    theme = "hyper",
    preview = {
      command = "viu -b -h 12 -w 70",
      file_path = home .. "/.config/nvim/static/akira-banner-01.png",
      file_height = 12,
      file_width = 70,
    },
    config = {
      week_header = {
        enable = false,
      },
      shortcut = {
        {
          icon = "  ",
          -- icon_hl = { fg = colors.red },
          desc = "lazy update",
          -- group = "Lazy",
          action = "Lazy update",
          key = "u",
        },
        {
          icon = "  ",
          -- icon_hl = { fg = colors.orange },
          desc = "lazy sync",
          -- group = "Lazy",
          action = "Lazy sync",
          key = "s",
        },
        {
          icon = "  ",
          -- icon_hl = { fg = colors.yellow },
          desc = "open mason",
          -- group = "Mason",
          action = "Mason",
          key = "m",
        },
        {
          icon = "  ",
          -- icon_hl = { fg = colors.green },
          desc = "find files",
          -- group = "Telescope",
          action = "Telescope find_files",
          key = "f",
        },
      },
      project = { limit = 5, icon = " " },
      mru = { limit = 5, icon = " " },
    }
  })
end

function config.nvim_tree()
  require("nvim-tree").setup({
    disable_netrw = false,
    hijack_cursor = true,
    hijack_netrw = true,
    sort_by = "type",
    view = {
      width = 25,
      signcolumn = "yes",
    },
    renderer = {
      highlight_opened_files = "all",
      root_folder_label = function()
        local cwd = vim.fn.getcwd()
        local user = "/home/rbmv"
        local home = "/home"
        if (cwd == user)
          then
            return "  " .. vim.fn.fnamemodify(cwd, ":t")
          elseif (cwd == home) then
            return "  " .. vim.fn.fnamemodify(cwd, ":t")
          else
            return "  " .. vim.fn.fnamemodify(cwd, ":t")
          end
      end,
      indent_markers = {
        enable = false,
        inline_arrows = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "│",
          bottom = "─",
          none = " ",
        },
      },
      icons = {
        webdev_colors = true,
        git_placement = "signcolumn",
        padding = " ",
        symlink_arrow = "  ",
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
        glyphs = {
          default = "",
          symlink = "",
          bookmark = "",
          folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
          git = {
            unstaged = " ",
            staged = " ",
            unmerged = "",
            renamed = "",
            untracked = " ",
            deleted = " ",
            ignored = "",
          },
        },
      },
      special_files = {
        "Cargo.toml",
        "Makefile",
        "README.md",
        "readme.md",
        "_quarto.yml",
        "mamba_env.yml",
        "environment.yml",
        "requirements.txt",
        "renv.lock",
        ".Rprofile",
      },
    },
    git = {
      enable = true,
      ignore = false,
      show_on_dirs = false,
      timeout = 400,
    },
    trash = {
      cmd = "trash-put",
      require_confirm = true,
    },
})
end

function config.scrollbar()
  require("modules.ui.scrollbar")
end

function config.gitsigns()
  require("gitsigns").setup({
    signs = {
      add = { hl = 'GitGutterAdd', text = '▋' },
      change = { hl = 'GitGutterChange', text = '▋' },
      delete = { hl = 'GitGutterDelete', text = '▋' },
      topdelete = { hl = 'GitGutterDeleteChange', text = '▔' },
      changedelete = { hl = 'GitGutterChange', text = '▎' },
      untracked = { hl = 'GitGutterAdd', text = '▋' },
    },
  })
  require("scrollbar.handlers.gitsigns").setup()
end

function config.hlslens()
  -- require("hlslens").setup() is not required
  require("scrollbar.handlers.search").setup({
    -- hlslens config overrides
    calm_down = true,
    nearest_float_when = "always",
  })
end

function config.noice()
  require("noice").setup({
    -- not sure if i'll override defaults or not
    -- since it's new/experimental
  })
end

return config
