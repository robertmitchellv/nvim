-- override some of navic's defaults
--
-- two things this file does:
--
-- 1. force eager-enough loading so navic's LSP-attach hook is in place
--    BEFORE LSPs attach to buffers. The default `lazy = true` causes a
--    race: navic only loads when something requires it (in our case,
--    the statusline's first draw), but by then `LspAttach` has already
--    fired and the attach hook missed it. Symptoms: navic shows nothing
--    until you manually run `:lua require("nvim-navic")`.
--
--    `event = "LspAttach"` tells lazy.nvim to load navic when ANY LSP
--    attaches. lazy.nvim guarantees the plugin is set up before the
--    autocmd fires, so our LspAttach handler (registered by the
--    LazyVim extra) gets to see the event.
--
-- 2. `highlight = false` is unnecessary now that we use get_data() via
--    statusline.format_navic — navic's get_location() (the one with
--    embedded highlights) is never called. But leaving it `false`
--    keeps things consistent in case any other code path falls back
--    to get_location().

return {
  "SmiteshP/nvim-navic",
  lazy = true,
  event = "LspAttach",
  opts = {
    highlight = false,
  },
}
