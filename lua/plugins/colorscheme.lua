-- tokyo night storm with a transparent statusline
-- * the on_colors and on_highlights overrides make sure the lualine
-- bubbles render against the terminal background rather than the
-- default statusline fill

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

        -- spelling squiggles in the storm palette's bright variants--tokyonight's
        -- defaults are too dim to spot at a glance
        hl.SpellBad = { undercurl = true, sp = "#ff899d" }
        hl.SpellCap = { undercurl = true, sp = "#c7a9ff" }
        hl.SpellRare = { undercurl = true, sp = "#faba4a" }
        hl.SpellLocal = { undercurl = true, sp = "#a4daff" }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
