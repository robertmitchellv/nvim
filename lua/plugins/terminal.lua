return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    cmd = "ToggleTerm",
    keys = { { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle ToggleTerm" } },
    opts = {
      open_mapping = [[<leader>tt]],
      hide_numbers = true,
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      close_on_exit = true,
    },
  },
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    dependencies = {
      "akinsho/nvim-toggleterm.lua",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },
}
