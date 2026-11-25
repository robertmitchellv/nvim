-- python debugging on top of the `dap.core` extra
-- * not via the `lang.python` extra--it would force plain `pyright` back on
--   over my basedpyright setup in lsp.lua

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "debugpy" } },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require("dap-python").test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require("dap-python").test_class() end, desc = "Debug Class", ft = "python" },
      },
      config = function()
        -- `debugpy-adapter` is the launcher mason puts on `PATH`; the program
        -- itself still runs in the project's own interpreter
        require("dap-python").setup("debugpy-adapter")
      end,
    },
  },
  -- keep mason-nvim-dap from registering a second python adapter over dap-python's
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      handlers = {
        python = function() end,
      },
    },
  },
}
