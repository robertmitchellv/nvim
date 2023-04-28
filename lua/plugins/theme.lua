return {
  -- colorscheme to be loaded
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  -- set colorscheme in LazyVim
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
