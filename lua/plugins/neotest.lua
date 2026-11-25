-- pytest through neotest, on top of the `test.core` extra

return {
  "nvim-neotest/neotest",
  dependencies = { "nvim-neotest/neotest-python" },
  opts = {
    adapters = {
      ["neotest-python"] = {},
    },
  },
}
