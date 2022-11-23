-- </> my scrollbar config 

-- </> setup
-- --> load scrollbar via protected call
local status_ok, scrollbar = pcall(require, "scrollbar")
if not status_ok then
  return
end

-- --> load tokyonight colors and utils
local status_ok, tokyo_colors = pcall(require, "tokyonight.colors")
if not status_ok then
  return
end
local colors = tokyo_colors.setup()
local util = require("tokyonight.util")

-- </> scrollbar
scrollbar.setup({
  show = true,
  show_in_active_only = false,
  set_highlights = true,
  folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
  max_lines = false, -- disables if no. of lines in buffer exceeds this
  hide_if_all_visible = false, -- Hides everything if all lines are visible
  handle = {
    text = " ",
    color = colors.bg_highlight,
    cterm = nil,
    hide_if_all_visible = true, -- Hides handle if all lines are visible
  },
  marks = {
    Cursor = {
      text = "•",
      priority = 0,
      color = nil,
      cterm = nil,
      highlight = "Normal",
    },
    Search = {
      text = { "-", "=" },
      priority = 1,
      color = colors.orange,
      cterm = nil,
    },
    Error = {
      text = { "-", "=" },
      priority = 2,
      color = colors.error,
      cterm = nil,
    },
    Warn = {
      text = { "-", "=" },
      priority = 3,
      color = colors.warning,
      cterm = nil,
    },
    Info = {
      text = { "-", "=" },
      priority = 4,
      color = colors.info,
      cterm = nil,
    },
    Hint = {
      text = { "-", "=" },
      priority = 5,
      color = colors.hint,
      cterm = nil,
    },
    Misc = {
      text = { "-", "=" },
      priority = 6,
      color = colors.purple,
      cterm = nil,
    },
    GitAdd = {
      text = "┆",
      priority = 7,
      color = nil,
      cterm = nil,
      highlight = "GitSignsAdd",
    },
    GitChange = {
      text = "┆",
      priority = 7,
      color = nil,
      cterm = nil,
      highlight = "GitSignsChange",
    },
    GitDelete = {
      text = "▁",
      priority = 7,
      color = nil,
      cterm = nil,
      highlight = "GitSignsDelete",
    },
  },
  excluded_buftypes = { "terminal", },
  excluded_filetypes = {
    "prompt",
    "TelescopePrompt",
    "noice",
  },
  autocmd = {
    render = {
      "BufWinEnter",
      "TabEnter",
      "TermEnter",
      "WinEnter",
      "CmdwinLeave",
      "TextChanged",
      "VimResized",
      "WinScrolled",
    },
    clear = {
      "BufWinLeave",
      "TabLeave",
      "TermLeave",
      "WinLeave",
    },
  },
  handlers = {
    cursor = true,
    diagnostic = true,
    gitsigns = false, -- Requires gitsigns
    handle = true,
    search = false, -- Requires hlslens
  },
})
