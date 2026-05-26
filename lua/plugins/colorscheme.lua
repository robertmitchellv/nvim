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
