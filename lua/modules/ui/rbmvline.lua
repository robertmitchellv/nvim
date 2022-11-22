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

-- --> custom colors for background bubbles
colors.galaxyGit = {}
colors.galaxyGit[1] = util.blend(colors.bg, colors.green, .4)
colors.galaxyGit[2] = util.blend(colors.bg, colors.green, .8)

-- --> vim mode colors
local mode_color = {
  ["!"] = colors.red,
  [""] = colors.blue,
  [""] = colors.orange,
  ["r?"] = colors.cyan,
  c = colors.magenta,
  ce = colors.red,
  cv = colors.red,
  i = colors.green,
  ic = colors.yellow,
  n = colors.red,
  no = colors.red,
  r = colors.cyan,
  R = colors.violet,
  rm = colors.cyan,
  Rv = colors.violet,
  s = colors.orange,
  S = colors.orange,
  t = colors.red,
  v = colors.blue,
  V = colors.blue,
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
        "hi GalaxyModeBarLeft guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)
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
        "hi GalaxyViMode guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)
      return "  "
    end,
  },
}

index = index + 1
gls.left[index] = {
  FirstSpacer = {
    provider = function()
      return " "
    end,
  },
}

index = index + 1
gls.left[index] = {
  BranchBubbleLeft = {
    provider = function()
      return separators.left
    end,
    highlight = { colors.galaxyGit[1], colors.bg },
  },
}

index = index + 1
gls.left[index] = {
  GitIcon = {
    provider = function()
      return "    "
    end,
    highlight = { colors.fg, colors.galaxyGit[1] },
    separator = separators.right,
    separator_highlight = { colors.galaxyGit[1], colors.galaxyGit[2] },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  GitIconBranch = {
    provider = function()
      return "   "
    end,
    highlight = { colors.fg, colors.galaxyGit[2] },
  },
}

index = index + 1
gls.left[index] = {
  GitBranch = {
    provider = "GitBranch",
    highlight = { colors.fg, colors.galaxyGit[2] },
    separator = separators.right,
    separator_highlight = { colors.galaxyGit[2], colors.bg },
    condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  SecondSpacer = {
    provider = function()
      return " "
    end,
  },
}

index = index + 1
gls.left[index] = {
  DiffAdd = {
    provider = "DiffAdd",
    icon = "  ",
    --highlight = { colors.diff.add, colors.bg },
    --condition = condition.check_git_workspace, 
  },
}

index = index + 1
gls.left[index] = {
  DiffModified = {
    provider = "DiffModified",
    icon = "  ",
    --highlight = { colors.diff.change, colors.bg },
    --condition = condition.check_git_workspace,
  },
}

index = index + 1
gls.left[index] = {
  DiffRemove = {
    provider = "DiffRemove",
    icon = "  ",
    --highlight = { colors.diff.delete, colors.bg },
    --condition = condition.check_git_workspace,
  },
}

--gls.left[12] = {
--  DiagnosticError = {
--    highlight = { colors.red, colors.bg },
--    icon = "  ",
--    provider = "DiagnosticError",
--  },
--}

--gls.left[13] = {
--  DiagnosticWarn = {
--    highlight = { colors.yellow, colors.bg },
--    icon = "  ",
--    provider = "DiagnosticWarn",
--  },
--}

--gls.left[14] = {
--  DiagnosticHint = {
--    highlight = { colors.cyan, colors.bg },
--    icon = "  ",
--    provider = "DiagnosticHint",
--  },
--}

--gls.left[15] = {
--  DiagnosticInfo = {
--    highlight = { colors.blue, colors.bg },
--    icon = "  ",
--    provider = "DiagnosticInfo",
--  },
--}

-- --> mid
index = 1
gls.mid[index] = {
  ShowLspClient = {
    condition = function()
      local tbl = { ["dashboard"] = true, [""] = true }
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
    highlight = { colors.yellow, colors.bg, "bold" },
    icon = "   lsp   ",
    provider = "GetLspClient",
  },
}

-- --> right
index = 1
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
  },
}

index = index + 1
gls.right[index] = {
  ModeBarRight = {
    provider = function()
      -- auto change color according the vim mode
      vim.api.nvim_command(
        "hi GalaxyModeBarRight guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)
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

