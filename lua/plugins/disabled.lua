return {
  -- i need to add this here so that lazyvim doesn't add its default
  -- welcome screen
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      scroll = { enabled = false },
    },
  },
}
