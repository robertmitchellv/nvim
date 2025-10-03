return {
  {
    "folke/snacks.nvim",
    opts = {
      -- have a different approach in large-file.lua
      bigfile = { enabled = false },
      -- have my own dashboard set up in ui.lua
      dashboard = { enabled = false },
      -- using mini-animate
      scroll = { enabled = false },
    },
    keys = {
      -- use a custom keymap in the vein of: toggle terminal
      {
        "<leader>tt",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
      },
    },
  },
}
