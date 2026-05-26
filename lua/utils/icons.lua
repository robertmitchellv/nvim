-- all icons i want to use in different parts of
-- my neovim config
local icons = {
  -- tier 1 (bookends): bright bg, dark text → vivid accent pills
  -- tier 2 (outer):    medium-dark bg, colored text → readable, present
  -- tier 3 (inner):    darkest bg, colored text → fades toward center
  bubbles = {
    -- text colors
    dark_fg = "#24283b", -- dark text for bright bookend bubbles
    light_fg = "#c0caf5", -- light text for neutral content (filenames, etc.)
    -- starship accent colors (used for bookend bg + semantic text)
    red = "#f7768e",
    orange = "#ff9e64",
    green = "#9ece6a",
    cyan_lt = "#b4f9f8",
    cyan = "#2ac3de",
    magenta = "#bb9af7",
    -- tier backgrounds (progressively darker toward center)
    -- tier 1: uses the accent colors directly (no bg entry needed)
    tier2_bg = "#292e42", -- medium-dark (bg_highlight from tokyo night storm)
    tier3_bg = "#1e2030", -- darkest (bg_dark, nearly transparent feel)
  },
  lualine = {
    bubble_left = "",
    bubble_right = "",
    left_bar = "▊ ",
    right_bar = " ▊",
    neovim_icon = " ",
    branch = " ",
    modified = " ",
    readonly = " ",
    unnamed = " ",
    newfile = " ",
    add = " ",
    change = " ",
    delete = " ",
    lsp_icon = "󱜙 ",
    error = " ",
    warn = " ",
    hint = " ",
    info = " ",
    select = " ",
    terminal = " ",
    replace = " ",
    status_right_arch = "󰣇 ",
    status_right_mac = " ",
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
      symlink_arrow = " ",
    },
    file = {
      modified = "󱇨 ",
    },
    git = {
      unstaged = " ",
      staged = " ",
      unmerged = " ",
      renamed = " ",
      untracked = " ",
      deleted = " ",
      ignored = " ",
      conflict = " ",
    },
  },
  dashboard = {
    lazy = "󰒲 ",
    update = " ",
    sync = "󱍸 ",
    mason = "󰰐 ",
    telescope = " ",
    exit = "󰩈 ",
    project = " ",
    mru = " ",
  },
  mason = {
    installed = "󰄳 ",
    pending = "󱍸 ",
    uninstalled = "󱑤 ",
  },
  gitblame = {
    author = " ",
    date = " ",
    summary = " ",
    uncomitted = "󱋽 ",
  },
}

return icons
