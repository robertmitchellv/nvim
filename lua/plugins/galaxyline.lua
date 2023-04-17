return {
  "nvimdev/galaxyline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
  event = "VeryLazy",
  opts = function()
    require("galaxyline").setup()
  end,
}
