-- </> my scrollbar config 

-- </> setup
-- --> load scrollbar via protected call
local status_scrollbar, scrollbar = pcall(require, "scrollbar")
if not status_scrollbar then
  return
end

-- --> load tokyonight colors and utils
local status_tokyo, tokyo_colors = pcall(require, "tokyonight.colors")
if not status_tokyo then
  return
end
local colors = tokyo_colors.setup()

-- </> scrollbar
scrollbar.setup({
  show = true,
  show_in_active_only = false,
  set_highlights = true,
  folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
  max_lines = false, -- disables if no. of lines in buffer exceeds this
  hide_if_all_visible = false, -- Hides everything if all lines are visible
  handle = { color = colors.bg_highlight },
  marks = {
    Cursor = {
      text = " ",
      highlight = "Normal",
    },
    Search = { color = colors.orange },
    Error = { color = colors.error },
    Warn = { color = colors.warning },
    Info = { color = colors.info },
    Hint = { color = colors.hint },
    Misc = { color = colors.purple },
    GitAdd = {
      text = "",
      color = colors.git.add,
      highlight = "GitSignsAdd",
    },
    GitChange = {
      text = "•",
      color = colors.git.change,
      highlight = "GitSignsChange",
    },
    GitDelete = {
      text = "",
      color = colors.git.delete,
      highlight = "GitSignsDelete",
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
