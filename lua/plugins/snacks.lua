-- the bottom slot holds either the shell or claude, never both--each toggle hides
-- the other first (claude's side is in claudecode.lua)
-- * claude is hidden with `simple_toggle`, never `close()`; `close()` stops the
--   process and ends the conversation
local function hide_claude()
  local ok, claude = pcall(require, "claudecode.terminal")
  local buf = ok and claude.get_active_terminal_bufnr()
  if buf and vim.fn.bufwinid(buf) ~= -1 then
    claude.simple_toggle()
  end
end

local function toggle_shell()
  hide_claude()
  Snacks.terminal()
end

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
      -- LazyVim's own `<c-/>`, but toggling the cwd terminal and clearing claude
      -- out of the slot first; a ctrl chord works from inside the terminal, where
      -- `<leader>` would just type a space
      -- NOTE: some terminals send `<c-_>` for ctrl-/
      { "<c-/>", toggle_shell, mode = { "n", "t" }, desc = "Toggle Terminal" },
      { "<c-_>", toggle_shell, mode = { "n", "t" }, desc = "which_key_ignore" },
      -- next to LazyVim's `<leader>ft` / `<leader>fT`, its other terminal launchers
      {
        "<leader>fd",
        function()
          Snacks.terminal("lazydocker")
        end,
        desc = "Lazydocker",
      },
    },
  },
}
