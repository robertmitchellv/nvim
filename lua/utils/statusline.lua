-- utils/statusline.lua
--
-- Helpers, predicates, and lookup tables for the lualine statusline.
-- The plugin file itself stays declarative: components + conditions.
-- The mechanics (bubble assembly, mode→color/icon, "is X available?")
-- live here.
--
-- Module surface:
--   M.conditions       -- predicates for `cond = ...`
--   M.mode_accent(b)   -- mode → bookend bg color (takes bubble palette)
--   M.mode_icon        -- mode → icon string
--   M.bubble(opts)     -- low-level: builds a single bubble
--   M.tier1/2/3(...)   -- high-level: pre-styled bubbles for each tier
--   M.format_navic()   -- format navic breadcrumbs as plain text (no escapes)
--
-- The tier helpers need a context with `ins`, `b` (bubbles palette), and
-- `icons` — see `M.new(ctx)` below, which returns a bound set of helpers.
--
-- USAGE PATTERN (in plugins/lualine.lua):
--
--   local LL = require("utils.statusline")
--   local icons = require("utils.icons")
--   local helpers = LL.new({ ins_left = ins_left, ins_right = ins_right,
--                            icons = icons, b = icons.bubbles })
--   helpers.tier1("left", { ... })
--   helpers.tier2("left", "branch", { fg = ..., gui = "bold" }, LL.conditions.in_git_repo)

local M = {}

-- ════════════════════════════════════════════════════════════════
-- CONDITIONS
--
-- All predicates live here. The plugin file references them by name.
-- Three classes of predicates:
--
--   LAYOUT     — about screen/buffer geometry (always cheap)
--   AVAILABLE  — is the data SOURCE present? (plugin loaded, LSP attached)
--   CONTENT    — is there meaningful CONTENT to show right now?
--
-- For most context bubbles you want AVAILABLE, not CONTENT — the bubble
-- being present is the signal that the source exists, and empty content
-- within it is fine. CONTENT predicates make bubbles flicker as data
-- comes and goes; AVAILABLE predicates make them stable for a session.
-- ════════════════════════════════════════════════════════════════
M.conditions = {
  -- ── LAYOUT ────────────────────────────────────────────────
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,

  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,

  hide_in_narrow_width = function()
    return vim.fn.winwidth(0) > 120
  end,

  -- ── AVAILABLE ─────────────────────────────────────────────
  in_git_repo = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,

  has_lsp_for_buffer = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      return false
    end
    local buf_ft = vim.bo[0].filetype
    for _, client in ipairs(clients) do
      local fts = client.config.filetypes
      if fts and vim.fn.index(fts, buf_ft) ~= -1 then
        return true
      end
    end
    return false
  end,

  navic_available = function()
    -- AVAILABLE-class: true whenever navic is attached, even if the
    -- cursor is currently outside any symbol. The bubble stays put for
    -- the duration of the buffer rather than flickering on/off.
    return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
  end,

  noice_mode_active = function()
    return package.loaded["noice"] and require("noice").api.status.mode.has()
  end,

  dap_active = function()
    return package.loaded["dap"] and require("dap").status() ~= ""
  end,

  -- ── CONTENT ───────────────────────────────────────────────
  has_diagnostics = function()
    return #vim.diagnostic.get(0) > 0
  end,

  is_recording = function()
    return vim.fn.reg_recording() ~= ""
  end,

  has_search = function()
    if vim.v.hlsearch == 0 then
      return false
    end
    local ok, sc = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
    return ok and sc.total and sc.total > 0
  end,
}

-- Combine multiple predicates with AND.
-- Usage: cond = LL.all(LL.conditions.hide_in_width, LL.conditions.has_lsp_for_buffer)
function M.all(...)
  local preds = { ... }
  return function()
    for _, p in ipairs(preds) do
      if not p() then
        return false
      end
    end
    return true
  end
end

-- ════════════════════════════════════════════════════════════════
-- MODE LOOKUPS
--
-- Mode → bookend color (depends on the bubble palette `b`, so it's a
-- factory). Mode → icon doesn't depend on anything but the icons module.
-- ════════════════════════════════════════════════════════════════
function M.mode_accent(b)
  return {
    n = b.red,
    no = b.red,
    i = b.green,
    v = b.magenta,
    [""] = b.magenta,
    V = b.magenta,
    s = b.orange,
    S = b.orange,
    [""] = b.orange,
    R = b.red,
    Rv = b.red,
    c = b.cyan,
    cv = b.cyan,
    ce = b.cyan,
    ["!"] = b.cyan,
    ic = b.cyan_lt,
    r = b.cyan_lt,
    rm = b.cyan_lt,
    ["r?"] = b.cyan_lt,
    t = b.cyan_lt,
  }
end

function M.mode_icon(icons)
  return {
    n = icons.lualine.neovim_icon,
    no = icons.lualine.neovim_icon,
    i = icons.lualine.change,
    v = icons.lualine.select,
    [""] = icons.lualine.select,
    V = icons.lualine.select,
    s = icons.lualine.select,
    S = icons.lualine.select,
    [""] = icons.lualine.select,
    R = icons.lualine.replace,
    Rv = icons.lualine.replace,
    c = icons.lualine.terminal,
    cv = icons.lualine.terminal,
    ce = icons.lualine.terminal,
    ["!"] = icons.lualine.terminal,
    ic = icons.lualine.neovim_icon,
    r = icons.lualine.neovim_icon,
    rm = icons.lualine.neovim_icon,
    ["r?"] = icons.lualine.neovim_icon,
    t = icons.lualine.neovim_icon,
  }
end

-- ════════════════════════════════════════════════════════════════
-- BUBBLE BUILDER
--
-- Collapses the three-component [bracket][content][bracket] pattern
-- into one call. All three share `cond` so they render or hide as a
-- single visual unit.
--
-- `bg` may be a color string OR a function returning a color (for
-- mode-reactive bookends). The bracket fg always tracks the inner bg.
-- ════════════════════════════════════════════════════════════════
function M.new(ctx)
  local ins_left = ctx.ins_left
  local ins_right = ctx.ins_right
  local icons = ctx.icons
  local b = ctx.b
  local mode_accent = M.mode_accent(b)

  local function bubble(opts)
    local side = opts.side
    local content = opts.content
    local bg = opts.bg
    local cond = opts.cond
    local content_color = opts.content_color or {}
    local padding = opts.padding or { left = 1, right = 1 }
    local outer_pad = opts.outer_pad or 1

    -- Resolve bracket color (matches inner bg, transparent outside)
    local bracket_color
    if type(bg) == "function" then
      bracket_color = function()
        return { fg = bg(), bg = "NONE" }
      end
    else
      bracket_color = { fg = bg, bg = "NONE" }
    end

    -- Resolve content color (merge bg into the caller's {fg, gui})
    local merged_color
    if type(bg) == "function" then
      merged_color = function()
        local c = vim.deepcopy(content_color)
        c.bg = bg()
        return c
      end
    else
      merged_color = vim.tbl_extend("force", content_color, { bg = bg })
    end

    local insert = side == "left" and ins_left or ins_right

    insert({
      function()
        return icons.lualine.bubble_left
      end,
      color = bracket_color,
      padding = { left = 0, right = 0 },
      cond = cond,
    })

    local content_component
    if type(content) == "string" then
      content_component = { content, color = merged_color, padding = padding, cond = cond }
    else
      content_component = vim.tbl_extend("force", content, {
        color = merged_color,
        padding = padding,
        cond = cond,
      })
    end
    insert(content_component)

    insert({
      function()
        return icons.lualine.bubble_right
      end,
      color = bracket_color,
      padding = { left = 0, right = outer_pad },
      cond = cond,
    })
  end

  -- ──────────────────────────────────────────────────────────
  -- TIER WRAPPERS
  --
  -- Each wrapper pre-fills the background for its tier:
  --   tier1 — mode-reactive bg, dark bold text (bookends)
  --   tier2 — fixed medium bg, caller picks fg
  --   tier3 — fixed dark bg, caller picks fg
  --
  -- Signature: tierN(side, content, content_color?, cond?)
  -- ──────────────────────────────────────────────────────────
  local function tier1(side, content, content_color, cond)
    bubble({
      side = side,
      content = content,
      bg = function()
        return mode_accent[vim.fn.mode()] or b.red
      end,
      cond = cond,
      content_color = content_color or { fg = b.dark_fg, gui = "bold" },
    })
  end

  local function tier2(side, content, content_color, cond)
    bubble({
      side = side,
      content = content,
      bg = b.tier2_bg,
      cond = cond,
      content_color = content_color,
    })
  end

  local function tier3(side, content, content_color, cond)
    bubble({
      side = side,
      content = content,
      bg = b.tier3_bg,
      cond = cond,
      content_color = content_color,
    })
  end

  return {
    bubble = bubble, -- escape hatch for special cases (e.g. compound content)
    tier1 = tier1,
    tier2 = tier2,
    tier3 = tier3,
  }
end

-- ════════════════════════════════════════════════════════════════
-- FORMATTERS
--
-- Pure functions that turn plugin data into bubble-ready strings.
-- Module-level (not bound to a context) — they're callable from
-- anywhere that has access to the source plugin's data.
-- ════════════════════════════════════════════════════════════════

-- Pre-define the highlight groups used by format_navic. Called once at
-- setup time and re-applied on ColorScheme changes so they survive a
-- theme reload. Each group has its bg pinned to tier3_bg so the colored
-- bits don't punch through the bubble background.
--
-- The "kind" → highlight mapping is intentionally coarse: most symbol
-- kinds use the same accent color so the breadcrumb reads as a unit.
-- If you want per-kind colors (Class one shade, Function another), this
-- is the function to extend.
function M.setup_navic_highlights(opts)
  opts = opts or {}
  local b = opts.bubbles or require("utils.icons").bubbles
  local set = function(name, fg)
    vim.api.nvim_set_hl(0, name, { fg = fg, bg = b.tier3_bg })
  end

  -- Three roles in the breadcrumb:
  set("NavicBubbleText", b.muted_fg or b.light_fg)
  set("NavicBubbleSeparator", b.dim_fg or b.muted_fg or b.light_fg)
  set("NavicBubbleIcon", b.accent or b.magenta)

  -- Re-apply on theme reload (e.g. :colorscheme or live reload)
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      M.setup_navic_highlights(opts)
    end,
  })
end

-- Wrap a string in a statusline highlight directive. `%*` resets to the
-- component's base color when the wrapped segment ends.
local function hl(group, text)
  return "%#" .. group .. "#" .. text .. "%*"
end

-- Format a navic breadcrumb path from raw symbol data.
--
-- Uses get_data() directly (not get_location()) so we own the rendering
-- and can apply our own muted color scheme via NavicBubble* highlight
-- groups (set up by M.setup_navic_highlights, which must be called once
-- at startup).
--
-- opts (all optional):
--   separator      string  — between path segments (default "  ")
--   show_icons     bool    — prepend each segment with its kind icon (default true)
--   depth_limit    number  — max segments before truncation (default 4)
--   truncate_from  string  — "start" or "end" — which end to drop (default "start"; keep the leaf)
--   truncate_mark  string  — indicator for elided segments (default "… ")
--   empty          string  — returned when no symbol path (default "")
--   colorize       bool    — emit %#…# highlight escapes (default true). Set false
--                            for plain text (falls back to bubble's base color).
function M.format_navic(opts)
  opts = opts or {}
  local separator = opts.separator or "  "
  local show_icons = opts.show_icons ~= false -- default true
  local depth_limit = opts.depth_limit or 4
  local truncate_from = opts.truncate_from or "start"
  local truncate_mark = opts.truncate_mark or "… "
  local empty = opts.empty or ""
  local colorize = opts.colorize ~= false -- default true

  if not package.loaded["nvim-navic"] then
    return empty
  end
  local navic = require("nvim-navic")
  if not navic.is_available() then
    return empty
  end

  local data = navic.get_data()
  if not data or #data == 0 then
    return empty
  end

  -- Apply depth limit by dropping from the chosen end.
  local segments = data
  local truncated = false
  if #segments > depth_limit then
    truncated = true
    if truncate_from == "end" then
      local kept = {}
      for i = 1, depth_limit do
        kept[i] = segments[i]
      end
      segments = kept
    else
      local kept = {}
      local start = #segments - depth_limit + 1
      for i = start, #segments do
        kept[#kept + 1] = segments[i]
      end
      segments = kept
    end
  end

  -- Format each segment. Three pieces per segment: icon, name, joining sep.
  local parts = {}
  for _, seg in ipairs(segments) do
    if show_icons and seg.icon and seg.icon ~= "" then
      if colorize then
        parts[#parts + 1] = hl("NavicBubbleIcon", seg.icon) .. hl("NavicBubbleText", seg.name)
      else
        parts[#parts + 1] = seg.icon .. seg.name
      end
    else
      if colorize then
        parts[#parts + 1] = hl("NavicBubbleText", seg.name)
      else
        parts[#parts + 1] = seg.name
      end
    end
  end

  local sep = colorize and hl("NavicBubbleSeparator", separator) or separator
  local result = table.concat(parts, sep)

  if truncated then
    local mark = colorize and hl("NavicBubbleSeparator", truncate_mark) or truncate_mark
    if truncate_from == "end" then
      result = result .. sep .. mark
    else
      result = mark .. result
    end
  end
  return result
end

return M
