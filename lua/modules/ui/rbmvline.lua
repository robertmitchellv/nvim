-- </> my custom galaxyline

-- </> setup
-- --> load galaxyline via protected call
-- load the conditions and create the line sections
local status_ok, galaxyline = pcall(require, "galaxyline")
if not status_ok then
  return
end
local condition = require("galaxyline.condition")
local gls = galaxyline.section
galaxyline.short_line_list = {"NvimTree","vista","dbui","packer"}

-- --> load tokyonight colors and utils
local status_ok, tokyo_colors = pcall(require, "tokyonight.colors")
if not status_ok then
  return
end
local colors = tokyo_colors.setup()
local util = require("tokyonight.util")

-- </> custom colors for git info
-- --> blend(fg, bg, alpha)
colors.galaxyGit = {}
colors.galaxyGit.icon_bg = util.blend(colors.purple, colors.bg, .8)
colors.galaxyGit.icon_fg = util.blend(colors.fg, colors.galaxyGit.icon_bg, .8)
colors.galaxyGit.branch_bg = util.blend(colors.purple, colors.bg, .5)
colors.galaxyGit.branch_fg = util.blend(colors.fg, colors.galaxyGit.branch_bg, .8)
colors.galaxyGit.add_bg = util.blend(colors.git.add, colors.bg, .5)
colors.galaxyGit.add_fg = util.blend(colors.fg, colors.galaxyGit.add_bg, .8)
colors.galaxyGit.change_bg = util.blend(colors.git.change, colors.bg, .5)
colors.galaxyGit.change_fg = util.blend(colors.fg, colors.galaxyGit.change_bg, .8)
colors.galaxyGit.delete_bg = util.blend(colors.git.delete, colors.bg, .5)
colors.galaxyGit.delete_fg = util.blend(colors.fg, colors.galaxyGit.delete_bg, .8)

-- </> custom colors for lsp info
-- --> blend(fg, bg, alpha)
colors.galaxyLsp = {}
colors.galaxyLsp.icon_bg = util.blend(colors.comment, colors.bg, .8)
colors.galaxyLsp.icon_fg = util.blend(colors.fg, colors.galaxyLsp.icon_bg, .8)
colors.galaxyLsp.name_bg = util.blend(colors.comment, colors.bg, .4)
colors.galaxyLsp.name_fg = util.blend(colors.fg, colors.galaxyLsp.name_bg, .8)

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

-- --> bubble separators
local separators = {
	left = "",
	right = "",
}

-- </> the status line
-- --> left
local index = 1
gls.left[index] = {
  ModeBarLeft = {
    provider = function()
      -- auto change color according the vim mode
      vim.api.nvim_command(
        "hi GalaxyModeBarLeft guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg_statusline)
      return "▊ "
    end,
  },
}

index = index + 1
gls.left[index] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      vim.api.nvim_command(
        "hi GalaxyViMode guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg_statusline)
      return "  "
    end,
  },
}

index = index + 1
gls.left[index] = {
  BranchBubbleLeft = {
    provider = function()
      return separators.left
    end,
    highlight = { colors.galaxyGit.icon_bg, colors.bg_statusline },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  GitIcon = {
    provider = function()
      return "    "
    end,
    highlight = { colors.galaxyGit.icon_fg, colors.galaxyGit.icon_bg },
    separator = separators.right,
    separator_highlight = { colors.galaxyGit.icon_bg, colors.galaxyGit.branch_bg },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  GitIconBranch = {
    provider = function()
      return "   "
    end,
    highlight = { colors.galaxyGit.branch_fg, colors.galaxyGit.branch_bg },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  GitBranch = {
    provider = "GitBranch",
    highlight = { colors.galaxyGit.branch_fg, colors.galaxyGit.branch_bg },
    separator = separators.right,
    separator_highlight = { colors.galaxyGit.branch_bg, colors.galaxyGit.add_bg },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  SecondSpacer = {
    provider = function()
      return " "
    end,
    highlight = { colors.fg, colors.galaxyGit.add_bg },
  },
}

index = index + 1
gls.left[index] = {
  DiffAdd = {
    provider = "DiffAdd",
    icon = "  ",
    highlight = { colors.galaxyGit.add_fg, colors.galaxyGit.add_bg },
    separator = separators.right,
    separator_highlight = { colors.galaxyGit.add_bg, colors.galaxyGit.change_bg },
    condition = condition.check_git_workspace, 
  },
}

index = index + 1
gls.left[index] = {
  DiffModified = {
    provider = "DiffModified",
    icon = "  ",
    highlight = { colors.galaxyGit.change_fg, colors.galaxyGit.change_bg },
    separator = separators.right,
    separator_highlight = { colors.galaxyGit.change_bg, colors.galaxyGit.delete_bg },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  DiffRemove = {
    provider = "DiffRemove",
    icon = "  ",
    highlight = { colors.galaxyGit.delete_fg, colors.galaxyGit.delete_bg },
    separator = separators.right,
    separator_highlight = { colors.galaxyGit.delete_bg, colors.bg_statusline },
    condition = condition.check_git_workspace,
  },
}

-- --> mid
index = 1
gls.mid[index] = {
  ShowLspBubbleLeft = {
    provider = function()
      return separators.left
    end,
    highlight = { colors.galaxyLsp.icon_bg, colors.bg_statusline },
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspIcon = {
    provider = function()
      return "  lsp  "
    end,
    highlight = { colors.galaxyLsp.icon_fg, colors.galaxyLsp.icon_bg },
    condition = function()
      local tbl = { ["dashboard"] = true, [""] = true }
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
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
    highlight = { colors.galaxyLsp.icon_fg, colors.galaxyLsp.icon_bg },
    separator = separators.right,
    separator_highlight = { colors.galaxyLsp.icon_bg, colors.galaxyLsp.name_bg },
    condition = function()
      local tbl = { ["dashboard"] = true, [""] = true }
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspNameStartSpacer = {
    provider = function()
      return " "
    end,
    highlight = { colors.galaxyLsp.name_fg, colors.galaxyLsp.name_bg },
    condition = function()
      local tbl = { ["dashboard"] = true, [""] = true }
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspClient = {
    provider = "GetLspClient",
    highlight = { colors.galaxyLsp.name_fg, colors.galaxyLsp.name_bg },
    condition = function()
      local tbl = { ["dashboard"] = true, [""] = true }
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspNameEndSpacer = {
    provider = function()
      return " "
    end,
    highlight = { colors.galaxyLsp.name_fg, colors.galaxyLsp.name_bg },
    condition = function()
      local tbl = { ["dashboard"] = true, [""] = true }
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
  },
}

index = index + 1
gls.mid[index] = {
  ShowLspBubbleRight = {
    provider = function()
      return ""
    end,
    highlight = { colors.galaxyLsp.icon_fg, colors.galaxyLsp.icon_bg },
    separator = separators.right,
    separator_highlight = { colors.galaxyLsp.name_bg, colors.bg_statusline },
    condition = function()
      local tbl = { ["dashboard"] = true, [""] = true }
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
  },
}

-- --> right
index = 1
gls.right[index] = {
  DiagnosticError = {
    highlight = { colors.red, colors.bg_statusline },
    icon = "  ",
    provider = "DiagnosticError",
  },
}

index = index + 1
gls.right[index] = {
  DiagnosticWarn = {
    highlight = { colors.yellow, colors.bg_statusline },
    icon = "  ",
    provider = "DiagnosticWarn",
  },
}

index = index + 1
gls.right[index] = {
  DiagnosticHint = {
    highlight = { colors.cyan, colors.bg_statusline },
    icon = "  ",
    provider = "DiagnosticHint",
  },
}

index = index + 1
gls.right[index] = {
  DiagnosticInfo = {
    highlight = { colors.blue, colors.bg },
    icon = "  ",
    provider = "DiagnosticInfo",
  },
}

index = index + 1
gls.right[index] = {
  FileEncode = {
    condition = condition.hide_in_width,
    highlight = { colors.green, colors.bg, "bold" },
    provider = "FileEncode",
    separator = " ",
    separator_highlight = { "NONE", colors.bg },
  },
}

index = index + 1
gls.right[index] = {
  FileFormat = {
    condition = condition.hide_in_width,
    highlight = { colors.green, colors.bg, "bold" },
    provider = "FileFormat",
    separator = " ",
    separator_highlight = { "NONE", colors.bg },
  },
}

index = index + 1
gls.right[index] = {
  Separator = {
    provider = function()
      return " "
    end,
    highlight = { colors.green, colors.bg_statusline },
  },
}

index = index + 1
gls.right[index] = {
  ModeBarRight = {
    provider = function()
      -- auto change color according the vim mode
      vim.api.nvim_command(
        "hi GalaxyModeBarRight guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg_statusline)
      return " ▊"
    end,
  },
}

-- --> short line
index = 1
gls.short_line_left[index] = {
  BufferType = {
    highlight = { colors.blue, colors.bg, "bold" },
    provider = "FileTypeName",
    separator = " ",
    separator_highlight = { "NONE", colors.bg },
  },
}

index = index + 1
gls.short_line_left[index] = {
  SFileName = {
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.bg, "bold" },
    provider = "SFileName",
  },
}

index = index + 1
gls.short_line_right[index] = {
  BufferIcon = {
    highlight = { colors.fg, colors.bg },
    provider = "BufferIcon",
  },
}

