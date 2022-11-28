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
galaxyline.short_line_list = { "NvimTree", "vista", "dbui", "packer"}

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
  status_icon =   "  ",
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
colors.galaxy.encoding_bg =     util.blend(colors.blue0, colors.bg, .5)
colors.galaxy.encoding_fg =     util.blend(colors.fg, colors.galaxy.encoding_bg, .8)
colors.galaxy.format_bg =       util.blend(colors.blue1, colors.bg, .5)
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
      return icons.status_icon
    end,
  },
}

index = index + 1
gls.left[index] = {
  BranchBubbleLeft = {
    provider = function()
      return icons.left_bubble
    end,
    highlight = { colors.galaxy.git_icon_bg, colors.bg_statusline },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  GitIcon = {
    provider = function()
      return icons.git
    end,
    highlight = { colors.galaxy.git_icon_fg, colors.galaxy.git_icon_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.git_icon_bg, colors.galaxy.branch_bg },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  GitIconBranch = {
    provider = function()
      return icons.branch
    end,
    highlight = { colors.galaxy.branch_fg, colors.galaxy.branch_bg },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  GitBranch = {
    provider = "GitBranch",
    highlight = { colors.galaxy.branch_fg, colors.galaxy.branch_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.branch_bg, colors.galaxy.add_bg },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  DiffAdd = {
    provider = "DiffAdd",
    icon = icons.add,
    highlight = { colors.galaxy.add_fg, colors.galaxy.add_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.add_bg, colors.galaxy.change_bg },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  DiffModified = {
    provider = "DiffModified",
    icon = icons.change,
    highlight = { colors.galaxy.change_fg, colors.galaxy.change_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.change_bg, colors.galaxy.delete_bg },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  DiffRemove = {
    provider = "DiffRemove",
    icon = icons.delete,
    highlight = { colors.galaxy.delete_fg, colors.galaxy.delete_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.delete_bg, colors.bg_statusline },
    condition = condition.check_git_workspace,
  },
}

-- --> mid
index = 1
gls.mid[index] = {
  ShowLspSpaceLeft = {
    provider = function()
      return " "
    end,
    highlight = { colors.fg, colors.bg_statusline },
    condition = HideDashboard(),
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspBubbleLeft = {
    provider = function()
      return icons.left_bubble
    end,
    highlight = { colors.galaxy.lsp_icon_bg, colors.bg_statusline },
    condition = HideDashboard(),
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspIcon = {
    provider = function()
      return icons.lsp_icon
    end,
    highlight = { colors.galaxy.lsp_icon_fg, colors.galaxy.lsp_icon_bg },
    condition = HideDashboard(),
  },
}

-- in the sections earlier separator/separator_highlight worked well;
-- with this section, it was moving them to places that didn't make sense
-- so I added extra space/separator sections to make it work
index = index + 1
gls.mid[index] = {
  ShowLspBubbleSeparator = {
    provider = function()
      return ""
    end,
    highlight = { colors.galaxy.lsp_icon_fg, colors.galaxy.lsp_icon_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.lsp_icon_bg, colors.galaxy.lsp_name_bg },
    condition = HideDashboard(),
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspNameStartSpacer = {
    provider = function()
      return " "
    end,
    highlight = { colors.galaxy.lsp_name_fg, colors.galaxy.lsp_name_bg },
    condition = HideDashboard(),
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspClient = {
    provider = "GetLspClient",
    highlight = { colors.galaxy.lsp_name_fg, colors.galaxy.lsp_name_bg },
    condition = HideDashboard(),
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspNameEndSpacer = {
    provider = function()
      return " "
    end,
    highlight = { colors.galaxy.lsp_name_fg, colors.galaxy.lsp_name_bg },
    condition = HideDashboard(),
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspBubbleRight = {
    provider = function()
      return ""
    end,
    highlight = { colors.galaxy.lsp_icon_fg, colors.galaxy.lsp_icon_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.lsp_name_bg, colors.bg_statusline },
    condition = HideDashboard(),
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspSpaceRight = {
    provider = function()
      return " "
    end,
    highlight = { colors.fg, colors.bg_statusline },
    condition = HideDashboard(),
  },
}

-- --> right
index = 1
gls.right[index] = {
  BubbleDiagnosticLeft = {
    provider = function()
      return icons.left_bubble
    end,
    highlight = { colors.galaxy.error_bg, colors.bg_statusline },
  },
}

index = index + 1
gls.right[index] = {
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = icons.error,
    highlight = { colors.galaxy.error_fg, colors.galaxy.error_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.error_bg, colors.galaxy.warn_bg },
  },
}

index = index + 1
gls.right[index] = {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = icons.warn,
    highlight = { colors.galaxy.warn_fg, colors.galaxy.warn_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.warn_bg, colors.galaxy.hint_bg },
  },
}

index = index + 1
gls.right[index] = {
  DiagnosticHint = {
    provider = "DiagnosticHint",
    icon = icons.hint,
    highlight = { colors.galaxy.hint_fg, colors.galaxy.hint_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.hint_bg, colors.galaxy.info_bg },
  },
}

index = index + 1
gls.right[index] = {
  DiagnosticInfo = {
    provider = "DiagnosticInfo",
    icon = icons.info,
    highlight = { colors.galaxy.info_fg, colors.galaxy.info_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.info_bg, colors.galaxy.bg_statusline },
  },
}

index = index + 1
gls.right[index] = {
  DiagnosticFileSpacer = {
    provider = function()
      return " "
    end,
    highlight = { "NONE", colors.bg_statusline },
    condition = condition.hide_in_width,
  },
}

index = index + 1
gls.right[index] = {
  BubbleFileEncodeLeft = {
    provider = function()
      return ""
    end,
    separator = icons.left_bubble,
    highlight = { "NONE", colors.bg_statusline },
    separator_highlight = { colors.galaxy.encoding_bg, colors.galaxy.bg_statusline },
    condition = condition.hide_in_width,
  },
}

index = index + 1
gls.right[index] = {
  FileEncode = {
    provider = "FileEncode",
    separator = icons.right_bubble,
    highlight = { colors.galaxy.encoding_fg, colors.galaxy.encoding_bg },
    separator_highlight = { colors.galaxy.encoding_bg, colors.galaxy.format_bg },
    condition = condition.hide_in_width,
  },
}

index = index + 1
gls.right[index] = {
  FileEndSeparator = {
    provider = function()
      return " "
    end,
    highlight = { "NONE", colors.bg_statusline },
  },
}

index = index + 1
gls.right[index] = {
  FileFormat = {
    provider = "FileFormat",
    highlight = { colors.galaxy.format_fg, colors.galaxy.format_bg },
    separator = icons.right_bubble,
    separator_highlight = { colors.galaxy.format_bg, colors.bg_statusline },
    condition = condition.hide_in_width,
  },
}

index = index + 1
gls.right[index] = {
  FileEndSeparator = {
    provider = function()
      return " "
    end,
    highlight = { colors.fg, colors.bg_statusline },
  },
}

index = index + 1
gls.right[index] = {
  ModeBarRight = {
    provider = function()
      local cmd = ModeColor("GalaxyModeBarRight", colors.bg_statusline)
      vim.api.nvim_command(cmd)
      return " ▊"
    end,
  },
}

-- --> short line
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
