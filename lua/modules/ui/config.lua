-- author: glepnr https://github.com/glepnir
-- date: 2022-07-02
-- License: MIT

local config = {}

function config.tokyonight()
  vim.cmd("colorscheme tokyonight")

  local tokyo = require("tokyonight")
  tokyo.setup({
    style = "storm",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
      sidebars = "dark",
      floats = "dark"
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
  db.session_directory = home .. "/.cache/nvim/session"
  db.preview_command = "viu -b -w 80 -h 15" -- make sure it matches what's set below
  db.preview_file_path = home .. "/.config/nvim/static/akira-banner-02.png"
  db.preview_file_height = 15
  db.preview_file_width = 80
  db.custom_header = nil
  db.custom_footer = nil
  db.header_pad = 0.2
  db.center_pad = 0.2
  db.footer_pad = 0.2
  db.custom_center = {
    {
      icon = "   ",
      icon_hl = { fg = colors.red },
      desc = "Update Plugins                          ",
      shortcut = "SPC p u",
      action = "PackerUpdate",
    },
    {
      icon = "   ",
      icon_hl = { fg = colors.orange },
      desc = "Sync Plugins                            ",
      shortcut = "SPC p s",
      action = "PackerSync",
    },
    {
      icon = "   ",
      icon_hl = { fg = colors.yellow },
      desc = "Update Mason                            ",
      shortcut = "SPC   m",
      action = "Mason",
    },
    {
      icon = "   ",
      icon_hl = { fg = colors.green },
      desc = "Find File                               ",
      shortcut = "SPC f f",
      action = "Telescope find_files find_command=rg,--hidden,--files",
    },
    {
      icon = "   ",
      icon_hl = { fg = colors.cyan },
      desc = "File Browser                            ",
      shortcut = "SPC   e",
      action = "Telescope file_browser",
    },
    {
      icon = "   ",
      icon_hl = { fg = colors.blue  },
      desc = "Find  word                              ",
      shortcut = "SPC f b",
      action = "Telescope live_grep",
    },
  }
end

function config.nvim_tree()
  require("nvim-tree").setup({
    disable_netrw = false,
    hijack_cursor = true,
    hijack_netrw = true,
  })
end

function config.scrollbar()
  require("modules.ui.scrollbar")
end

function config.gitsigns()
  if not packer_plugins["plenary.nvim"].loaded then
    vim.cmd([[packadd plenary.nvim]])
  end
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

return config
