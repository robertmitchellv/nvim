-- </> my custom galaxyline

-- </> setup
-- --> load galaxyline via protected call
-- load the conditions and create the line sections and fileinfo
local status_galaxy, galaxyline = pcall(require, "galaxyline")
if not status_galaxy then
  return
end
local condition = require("galaxyline.condition")
local gls = galaxyline.section
galaxyline.short_line_list = { "NvimTree", "vista", "dbui", "packer", "lspsagaoutline" }

-- --> load tokyonight colors and utils
local status_tokyo, tokyo_colors = pcall(require, "tokyonight.colors")
if not status_tokyo then
  return
end
local colors = tokyo_colors.setup()
local util = require("tokyonight.util")

-- </> custom icons 
-- --> blend(fg, bg, alpha)
local icons = {
  left_bar =      "▊ ",
  right_bar =     " ▊",
  left_bubble =   "",
	right_bubble =  "",
  status_left =   "  ",
  git =           "    ",
  branch =        "   ",
  add =           "  ",
  change =        "  ",
  delete =        "  ",
  lsp_icon =      "  lsp   ",
  error =         "  ",
  warn =          "  ",
  hint =          "  ",
  info =          "  ",
  status_right =   "  ",
}

-- </> custom colors for git info
-- --> blend(fg, bg, alpha)
colors.galaxy = {}
colors.galaxy.git_icon_bg =     util.blend(colors.purple, colors.bg, .8)
colors.galaxy.git_icon_fg =     util.blend(colors.fg, colors.galaxy.git_icon_bg, .8)
colors.galaxy.branch_bg =       util.blend(colors.purple, colors.bg, .5)
colors.galaxy.branch_fg =       util.blend(colors.fg, colors.galaxy.branch_bg, .8)
colors.galaxy.add_bg =          util.blend(colors.git.add, colors.bg, .5)
colors.galaxy.add_fg =          util.blend(colors.fg, colors.galaxy.add_bg, .8)
colors.galaxy.change_bg =       util.blend(colors.git.change, colors.bg, .5)
colors.galaxy.change_fg =       util.blend(colors.fg, colors.galaxy.change_bg, .8)
colors.galaxy.delete_bg =       util.blend(colors.git.delete, colors.bg, .5)
colors.galaxy.delete_fg =       util.blend(colors.fg, colors.galaxy.delete_bg, .8)
colors.galaxy.lsp_icon_bg =     util.blend(colors.comment, colors.bg, .8)
colors.galaxy.lsp_icon_fg =     util.blend(colors.fg, colors.galaxy.lsp_icon_bg, .8)
colors.galaxy.lsp_name_bg =     util.blend(colors.comment, colors.bg, .4)
colors.galaxy.lsp_name_fg =     util.blend(colors.fg, colors.galaxy.lsp_name_bg, .8)
colors.galaxy.error_bg =        util.blend(colors.error, colors.bg, .5)
colors.galaxy.error_fg =        util.blend(colors.fg, colors.galaxy.error_bg, .8)
colors.galaxy.warn_bg =         util.blend(colors.warning, colors.bg, .5)
colors.galaxy.warn_fg =         util.blend(colors.fg, colors.galaxy.warn_bg, .8)
colors.galaxy.hint_bg =         util.blend(colors.hint, colors.bg, .5)
colors.galaxy.hint_fg =         util.blend(colors.fg, colors.galaxy.hint_bg, .8)
colors.galaxy.info_bg =         util.blend(colors.info, colors.bg, .5)
colors.galaxy.info_fg =         util.blend(colors.fg, colors.galaxy.info_bg, .8)
colors.galaxy.encoding_bg =     util.blend(colors.blue, colors.bg, .5)
colors.galaxy.encoding_fg =     util.blend(colors.fg, colors.galaxy.encoding_bg, .8)
colors.galaxy.format_bg =       util.blend(colors.blue, colors.bg, .8)
colors.galaxy.format_fg =       util.blend(colors.fg, colors.galaxy.format_bg, .8)

-- </> util functions
-- auto change color according the vim mode and return icon
function ModeColor(name, bg)
  -- --> vim mode colors
  local mode_color = {
    -- command
    c = colors.yellow, -- command
    ce = colors.yellow, -- ex
    cv = colors.yellow, -- vim ex
    ["!"] = colors.yellow, -- shell
    -- insert
    i = colors.green, -- insert
    -- normal
    n = colors.blue, -- normal
    no = colors.blue, -- n-operator pending
    -- replace
    R = colors.red, -- replace
    Rv = colors.red, -- v-replace
    -- visual
    v = colors.magenta, -- visual
    V = colors.magenta, -- v-line
    [""] = colors.magenta, -- v-block
    -- select
    s = colors.orange, -- select
    S = colors.orange, -- s-line
    [""] = colors.orange, -- s-block
    -- other
    ic = colors.teal, -- ?
    r = colors.teal, -- prompt
    rm = colors.teal, -- more
    ["r?"] = colors.teal, -- confirm
    t = colors.teal,
  }
  local current_mode = mode_color[vim.fn.mode()]
  return string.format([[hi %s guifg=%s guibg=%s]], name, current_mode, bg)
end

function HideDashboard()
  local tbl = { ["dashboard"] = true, [""] = true }
  if tbl[vim.bo.filetype] then
    return false
  end
  return true
end

-- </> the status line
-- condition -> highlight -> icon -> provider -> separator -> separator_highlight
-- --> left
local index = 1
gls.left[index] = {
  ModeBarLeft = {
    provider = function()
      local cmd = ModeColor("GalaxyModeBarLeft", colors.bg_statusline)
      vim.api.nvim_command(cmd)
      return icons.left_bar
    end,
  },
}

index = index + 1
gls.left[index] = {
  ViMode = {
    provider = function()
      local cmd = ModeColor("GalaxyViMode", colors.bg_statusline)
      vim.api.nvim_command(cmd)
      return icons.status_left
    end,
  },
}

index = index + 1
gls.left[index] = {
  BranchBubbleLeft = {
    condition = condition.check_git_workspace,
    highlight = { colors.galaxy.git_icon_bg, colors.bg_statusline },
    provider = function()
      return icons.left_bubble
    end,
  },
}

index = index + 1
gls.left[index] = {
  GitIcon = {
    condition = condition.check_git_workspace,
    highlight = { colors.galaxy.git_icon_fg, colors.galaxy.git_icon_bg },
    provider = function()
      return icons.git
    end,
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.git_icon_bg, colors.galaxy.branch_bg },
  },
}

index = index + 1
gls.left[index] = {
  GitIconBranch = {
    condition = condition.check_git_workspace,
    highlight = { colors.galaxy.branch_fg, colors.galaxy.branch_bg },
    provider = function()
      return icons.branch
    end,
  },
}

index = index + 1
gls.left[index] = {
  GitBranch = {
    condition = condition.check_git_workspace,
    highlight = { colors.galaxy.branch_fg, colors.galaxy.branch_bg },
    provider = "GitBranch",
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.branch_bg, colors.galaxy.add_bg },
  },
}

index = index + 1
gls.left[index] = {
  DiffAdd = {
    condition = condition.check_git_workspace,
    highlight = { colors.galaxy.add_fg, colors.galaxy.add_bg },
    icon = icons.add,
    provider = "DiffAdd",
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.add_bg, colors.galaxy.change_bg },
  },
}

index = index + 1
gls.left[index] = {
  DiffModified = {
    condition = condition.check_git_workspace,
    highlight = { colors.galaxy.change_fg, colors.galaxy.change_bg },
    icon = icons.change,
    provider = "DiffModified",
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.change_bg, colors.galaxy.delete_bg },
  },
}

index = index + 1
gls.left[index] = {
  DiffRemove = {
    condition = condition.check_git_workspace,
    highlight = { colors.galaxy.delete_fg, colors.galaxy.delete_bg },
    icon = icons.delete,
    provider = "DiffRemove",
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.delete_bg, colors.bg_statusline },
  },
}

-- --> mid
index = 1
gls.mid[index] = {
  ShowLspBubbleStart = {
    condition = HideDashboard(),
    highlight = { colors.galaxy.lsp_icon_bg, colors.bg_statusline },
    provider = function()
      return icons.left_bubble
    end,
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspIcon = {
    condition = HideDashboard(),
    highlight = { colors.galaxy.lsp_icon_fg, colors.galaxy.lsp_icon_bg },
    provider = function()
      return icons.lsp_icon
    end,
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspBubble = {
    condition = HideDashboard(),
    highlight = { colors.galaxy.lsp_icon_bg, colors.galaxy.lsp_name_bg },
    provider = function()
      return icons.right_bubble
    end,
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspNameSpacerStart = {
    condition = HideDashboard(),
    highlight = { colors.galaxy.lsp_name_fg, colors.galaxy.lsp_name_bg },
    provider = function()
      return " "
    end,
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspClient = {
    condition = HideDashboard(),
    highlight = { colors.galaxy.lsp_name_fg, colors.galaxy.lsp_name_bg },
    provider = "GetLspClient",
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspNameSpacerEnd = {
    condition = HideDashboard(),
    highlight = { colors.galaxy.lsp_name_fg, colors.galaxy.lsp_name_bg },
    provider = function()
      return " "
    end,
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspBubbleEnd = {
    condition = HideDashboard(),
    highlight = { colors.galaxy.lsp_name_bg, colors.bg_statusline },
    provider = function()
      return icons.right_bubble
    end,
  },
}

-- --> right
index = 1
gls.right[index] = {
  DiagnosticError = {
    highlight = { colors.galaxy.error_fg, colors.galaxy.error_bg },
    icon = icons.error,
    provider = "DiagnosticError",
    separator = icons.left_bubble,
    separator_highlight = { colors.galaxy.error_bg, colors.bg_statusline },
  },
}

index = index + 1
gls.right[index] = {
  DiagnosticWarn = {
    highlight = { colors.galaxy.warn_fg, colors.galaxy.warn_bg },
    icon = icons.warn,
    provider = "DiagnosticWarn",
    separator = icons.left_bubble,
    separator_highlight = { colors.galaxy.warn_bg, colors.galaxy.error_bg },
  },
}

index = index + 1
gls.right[index] = {
  DiagnosticHint = {
    highlight = { colors.galaxy.hint_fg, colors.galaxy.hint_bg },
    icon = icons.hint,
    provider = "DiagnosticHint",
    separator = icons.left_bubble,
    separator_highlight = { colors.galaxy.hint_bg, colors.galaxy.warn_bg },
  },
}

index = index + 1
gls.right[index] = {
  DiagnosticInfo = {
    highlight = { colors.galaxy.info_fg, colors.galaxy.info_bg },
    icon = icons.info,
    provider = "DiagnosticInfo",
    separator = icons.left_bubble,
    separator_highlight = { colors.galaxy.info_bg, colors.galaxy.hint_bg },
  },
}

index = index + 1
gls.right[index] = {
  FileEncode = {
    condition = condition.hide_in_width,
    highlight = { colors.galaxy.encoding_fg, colors.galaxy.encoding_bg },
    provider = "FileEncode",
    separator = icons.left_bubble,
    separator_highlight = { colors.galaxy.encoding_bg, colors.galaxy.info_bg },
  },
}

index = index + 1
gls.right[index] = {
  EncodeSpacer = {
    condition = condition.hide_in_width,
    highlight = { colors.galaxy.encoding_fg, colors.galaxy.encoding_bg },
    provider = function()
      return " "
    end,
  },
}

index = index + 1
gls.right[index] = {
  FileFormat = {
    condition = condition.hide_in_width,
    highlight = { colors.galaxy.format_fg, colors.galaxy.format_bg },
    provider = "FileFormat",
    separator = icons.left_bubble,
    separator_highlight = { colors.galaxy.format_bg, colors.galaxy.encoding_bg },
  },
}

index = index + 1
gls.right[index] = {
  BubbleFileEnd = {
    highlight = { colors.galaxy.format_bg, colors.bg_statusline },
    provider = function()
      return icons.right_bubble
    end,
  },
}

index = index + 1
gls.right[index] = {
  FileEndSeparator = {
    highlight = { colors.fg, colors.bg_statusline },
    provider = function()
      return " "
    end,
  },
}

index = index + 1
gls.right[index] = {
  StatusRight = {
    provider = function()
      local cmd = ModeColor("GalaxyStatusRight", colors.bg_statusline)
      vim.api.nvim_command(cmd)
      return icons.status_right
    end,
  },
}

index = index + 1
gls.right[index] = {
  ModeBarRight = {
    provider = function()
      local cmd = ModeColor("GalaxyModeBarRight", colors.bg_statusline)
      vim.api.nvim_command(cmd)
      return icons.right_bar
    end,
  },
}

-- </> short line
-- --> needs work
index = 1
gls.short_line_left[index] = {
  BufferType = {
    highlight = { colors.blue, colors.bg_statusline, "bold" },
    provider = "FileTypeName",
    separator = " ",
    separator_highlight = { "NONE", colors.bg_statusline },
  },
}

index = index + 1
gls.short_line_left[index] = {
  SFileName = {
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.bg_statusline, "bold" },
    provider = "SFileName",
  },
}

index = index + 1
gls.short_line_right[index] = {
  BufferIcon = {
    highlight = { colors.fg, colors.bg_statusline },
    provider = "BufferIcon",
  },
}
