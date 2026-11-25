return {
  {
    "folke/snacks.nvim",
    opts = {
      -- one threshold for every filetype--5MB is the old `*.xml` cutoff, the
      -- strictest of the per-pattern sizes `faster.nvim` had
      bigfile = { size = 5 * 1024 * 1024 },
      -- have my own dashboard set up in dashboard.lua
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
      {
        "<leader>td",
        function()
          Snacks.terminal("lazydocker")
        end,
        desc = "Lazydocker",
      },
    },
  },
}
