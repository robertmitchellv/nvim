-- helpers, predicates, and lookup tables for the lualine statusline
-- * the plugin file itself stays declarative: components + conditions
-- * the mechanics (bubble assembly, mode→color/icon, "is X available?")
-- live here
--
-- module surface:
--   M.conditions       -- predicates for `cond = ...`
--   M.mode_accent(b)   -- mode → bookend bg color (takes bubble palette)
--   M.mode_icon        -- mode → icon string
--   M.bubble(opts)     -- low-level: builds a single bubble
--   M.tier1/2/3(...)   -- high-level: pre-styled bubbles for each tier
--
-- the tier helpers need a context with `ins`, `b` (bubbles palette), and
-- `icons` — see `M.new(ctx)` below, which returns a bound set of helpers.
--
-- USAGE PATTERN (in plugins/lualine.lua):
--
--   local LL = require("utils.lualine")
--   local icons = require("utils.icons")
--   local helpers = LL.new({ ins_left = ins_left, ins_right = ins_right,
--                            icons = icons, b = icons.bubbles })
--   helpers.tier1("left", { ... })
--   helpers.tier2("left", "branch", { fg = ..., gui = "bold" }, LL.conditions.in_git_repo)

local M = {}

-- ════════════════════════════════════════════════════════════════
-- CONDITIONS
--
-- all predicates live here. The plugin file references them by name
-- three classes of predicates:
--
--   LAYOUT     — about screen/buffer geometry (always cheap)
--   AVAILABLE  — is the data SOURCE present? (plugin loaded, LSP attached)
--   CONTENT    — is there meaningful CONTENT to show right now?
--
-- for most context bubbles you want AVAILABLE, not CONTENT — the bubble
-- being present is the signal that the source exists, and empty content
-- within it is fine. CONTENT predicates make bubbles flicker as data
-- comes and goes; AVAILABLE predicates make them stable for a session
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

-- combine multiple predicates with AND
-- usage: cond = LL.all(LL.conditions.hide_in_width, LL.conditions.has_lsp_for_buffer)
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
-- mode → bookend color (depends on the bubble palette `b`, so it's a
-- factory). mode → icon doesn't depend on anything but the icons module
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
-- collapses the three-component [bracket][content][bracket] pattern
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
  -- each wrapper pre-fills the background for its tier:
  --   tier1 — mode-reactive bg, dark bold text (bookends)
  --   tier2 — fixed medium bg, caller picks fg
  --   tier3 — fixed dark bg, caller picks fg
  --
  -- signature: tierN(side, content, content_color?, cond?)
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

return M
