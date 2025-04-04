return {
  {
    "mgierada/lazydocker.nvim",
    dependencies = { "akinsho/toggleterm.nvim" },
    config = function()
      require("lazydocker").setup({
        -- valid options are "single" | "double" | "shadow" | "curved"
        border = "curved",
      })
    end,
    event = "BufRead",
    keys = {
      {
        "<leader>td",
        function()
          require("lazydocker").open()
        end,
        desc = "Open Lazydocker floating window",
      },
    },
  },
}
