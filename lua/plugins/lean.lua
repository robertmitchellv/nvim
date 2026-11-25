return {
  -- lean.nvim starts the Lean LSP itself (via `lake serve`) and adds the
  -- infoview--so no mason or lspconfig entry for `leanls`
  -- NOTE: not using LazyVim's `lang.lean` extra on purpose; it still passes
  -- `opts` to a `setup()` that lean.nvim no longer has
  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },
    -- configured through `vim.g.lean_config`, not `setup()`--so `init`, not `opts`
    init = function()
      ---@type lean.Config
      vim.g.lean_config = {
        -- `<LocalLeader>i` toggles the infoview, `<LocalLeader>` is `\` in LazyVim
        mappings = true,
      }
    end,
  },
}
