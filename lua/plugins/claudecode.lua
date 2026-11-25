-- claude runs in a snacks terminal sharing the full-width bottom slot with the
-- shell--only one is up at a time (the shell's side is in snacks.lua)
-- * launched by the plugin, so `claude` connects to the editor without `/ide`
-- * `VeryLazy` so the ide server is up even before claude is first toggled
-- * diffs get a tab of their own with no terminal in it--side by side next to a
--   terminal is too tight at my font size
-- * claude is hidden with `simple_toggle`, never `close()`; `close()` stops the
--   process and ends the conversation

local function hide_shell()
  local shell = Snacks.terminal.get(nil, { create = false })
  if shell and shell:win_valid() then
    shell:hide()
  end
end

local function toggle_claude()
  hide_shell()
  require("claudecode.terminal").simple_toggle()
end

return {
  "coder/claudecode.nvim",
  event = "VeryLazy",
  opts = {
    terminal = {
      provider = "snacks",
      snacks_win_opts = {
        position = "bottom",
        height = 0.4,
        -- inside claude, `<c-/>` hides it, so that chord always means "clear the
        -- bottom slot" from within it
        -- NOTE: same names as LazyVim's terminal keys (`plugins/util.lua`) so these
        -- replace its plain `hide` rather than map the chord twice
        keys = {
          hide_slash = { "<C-/>", toggle_claude, desc = "Hide Claude", mode = { "n", "t" } },
          hide_underscore = { "<C-_>", toggle_claude, desc = "which_key_ignore", mode = { "n", "t" } },
        },
      },
    },
    diff_opts = {
      open_in_new_tab = true,
      hide_terminal_in_new_tab = true,
    },
  },
  keys = {
    { "<leader>ac", toggle_claude, desc = "Toggle Claude" },
  },
}
