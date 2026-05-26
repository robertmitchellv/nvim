-- statusline configuration; the mechanics (bubble assembly, predicates,
-- mode lookups) live in utils.statusline — this file is declarative
--
-- LAYOUT
--   LEFT:  [mode] [branch?] [file] [diff] [navic?]            ← center
--   RIGHT:                center →  [search?] [recording?]
--                                   [noice?] [dap?]
--                                   [diag?] [lsp?] [arch]
--
-- TIERS (visual nesting; ? = conditional)
--   tier 1 — bright mode-reactive bg, dark bold text (bookends only)
--   tier 2 — medium-dark bg, semantic colors
--   tier 3 — darkest bg, semantic colors (fades toward center)
--
-- PREDICATE CLASSES
--   LAYOUT     — geometry only (hide_in_width)
--   AVAILABLE  — data source present (in_git_repo, navic_available, …)
--   CONTENT    — actual non-empty data right now (has_diagnostics, …)
--
-- most context bubbles use AVAILABLE so they're stable across the
-- session. Diagnostics, search, recording use CONTENT because they're
-- inherently transient.

local icons = require("utils.icons")
local statusline = require("utils.statusline")
local conditions = statusline.conditions

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local b = icons.bubbles
    local colors = require("tokyonight.colors").setup()
    local mode_icon = statusline.mode_icon(icons)

    -- Define the NavicBubble* highlight groups (text, separator, icon).
    -- Each pinned to tier3_bg so the colored segments don't punch
    -- through the bubble's background fill. Re-applied on ColorScheme
    -- changes by the setup function itself.
    statusline.setup_navic_highlights({ bubbles = b })

    local config = {
      options = {
        component_separators = "",
        section_separators = "",
        theme = {
          normal = { c = { fg = colors.fg, bg = "NONE" } },
          inactive = { c = { fg = colors.fg, bg = "NONE" } },
        },
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "neo-tree", "lazy", "mason" },
        },
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    }

    local function ins_left(c)
      table.insert(config.sections.lualine_c, c)
    end
    local function ins_right(c)
      table.insert(config.sections.lualine_x, c)
    end

    local H = statusline.new({
      ins_left = ins_left,
      ins_right = ins_right,
      icons = icons,
      b = b,
    })

    -- ══════════════════════════════════════════════════════════
    -- LEFT SIDE
    -- ══════════════════════════════════════════════════════════

    -- mode bookend (tier 1, always)
    H.tier1("left", {
      function()
        return mode_icon[vim.fn.mode()] or ""
      end,
    })

    -- git branch (tier 2, only in repo)
    H.tier2("left", { "branch", icon = icons.lualine.branch }, { fg = b.magenta, gui = "bold" }, conditions.in_git_repo)

    -- filename + filetype icon (tier 2, always when buffer is non-empty)
    -- compound content needs the escape hatch — two adjacent components
    -- glued inside one bubble — so we use H.bubble directly rather than a
    -- tier wrapper. Brackets + cond stay coordinated
    do
      local function bracket(char, pad)
        ins_left({
          function()
            return char
          end,
          color = { fg = b.tier2_bg, bg = "NONE" },
          padding = pad,
          cond = conditions.buffer_not_empty,
        })
      end
      bracket(icons.lualine.bubble_left, { left = 0, right = 0 })
      ins_left({
        "filetype",
        icon_only = true,
        color = { bg = b.tier2_bg },
        padding = { left = 1, right = 0 },
        cond = conditions.buffer_not_empty,
      })
      ins_left({
        "filename",
        path = 0,
        symbols = {
          modified = icons.lualine.modified,
          readonly = icons.lualine.readonly,
          unnamed = icons.lualine.unnamed,
          newfile = icons.lualine.newfile,
        },
        color = { fg = b.light_fg, bg = b.tier2_bg, gui = "italic" },
        padding = { left = 1, right = 1 },
        cond = conditions.buffer_not_empty,
      })
      bracket(icons.lualine.bubble_right, { left = 0, right = 1 })
    end

    -- git diff (tier 3, in repo + width allows)
    -- we read from `vim.b.minidiff_summary` because mini-diff is the
    -- active git tracker (configured via LazyVim extras). the
    -- minidiff_summary table is updated on every text change (200ms
    -- debounced) so the bubble reflects unsaved edits in real time
    --
    -- without the explicit `source`, lualine's diff component falls back
    -- to scanning gitsigns (not installed) or shelling out to `git diff`
    -- (only sees saved changes). Either way: no live updates
    H.tier3("left", {
      "diff",
      source = function()
        local s = vim.b.minidiff_summary
        if not s then
          return nil
        end
        return {
          added = s.add or 0,
          modified = s.change or 0,
          removed = s.delete or 0,
        }
      end,
      symbols = {
        added = icons.lualine.add,
        modified = icons.lualine.change,
        removed = icons.lualine.delete,
      },
      diff_color = {
        added = { fg = b.green, bg = b.tier3_bg },
        modified = { fg = b.cyan, bg = b.tier3_bg },
        removed = { fg = b.red, bg = b.tier3_bg },
      },
    }, nil, statusline.all(conditions.hide_in_width, conditions.in_git_repo))

    -- navic breadcrumbs (tier 3, when navic is attached)
    -- uses statusline.format_navic() to render the symbol path as plain
    -- text from get_data(), owning the highlights via the bubble rather
    -- than letting navic inject its own (which would break tier3_bg
    -- mid-string with NavicIcons*/NavicText escape sequences).
    H.tier3("left", {
      function()
        return statusline.format_navic({ depth_limit = 4 })
      end,
    }, { fg = b.light_fg }, conditions.navic_available)

    -- ══════════════════════════════════════════════════════════
    -- RIGHT SIDE  (declared inner→outer; renders left→right)
    -- ══════════════════════════════════════════════════════════

    -- search count (tier 3, only when searching)
    H.tier3("right", {
      function()
        local ok, sc = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
        if not ok or not sc.total or sc.total == 0 then
          return ""
        end
        return string.format("%s %d/%d", icons.lualine.search or "", sc.current, sc.total)
      end,
    }, { fg = b.cyan_lt }, conditions.has_search)

    -- macro recording (tier 3, only while recording)
    H.tier3("right", {
      function()
        return string.format("%s recording @%s", icons.lualine.record or "", vim.fn.reg_recording())
      end,
    }, { fg = b.red, gui = "bold" }, conditions.is_recording)

    -- noice mode (tier 3, only when active)
    H.tier3("right", {
      function()
        return require("noice").api.status.mode.get()
      end,
    }, { fg = b.orange }, conditions.noice_mode_active)

    -- dap status (tier 3, only when debugging)
    H.tier3("right", {
      function()
        return icons.lualine.error .. require("dap").status()
      end,
    }, { fg = b.red }, conditions.dap_active)

    -- diagnostics (tier 2, only when issues exist)
    -- CONTENT-class: bubble disappears when count is zero. The diagnostics
    -- component handles its own rendering, the predicate just gates the
    -- bracket visibility
    H.tier2("right", {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = {
        error = icons.lualine.error,
        warn = icons.lualine.warn,
        info = icons.lualine.info,
        hint = icons.lualine.hint,
      },
      diagnostics_color = {
        error = { fg = b.red, bg = b.tier2_bg },
        warn = { fg = b.orange, bg = b.tier2_bg },
        info = { fg = b.cyan, bg = b.tier2_bg },
        hint = { fg = b.green, bg = b.tier2_bg },
      },
    }, nil, conditions.has_diagnostics)

    -- lsp server name (tier 2, only when LSP attached for this filetype)
    H.tier2("right", {
      function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local buf_ft = vim.bo[0].filetype
        for _, client in ipairs(clients) do
          local fts = client.config.filetypes
          if fts and vim.fn.index(fts, buf_ft) ~= -1 then
            return client.name
          end
        end
        return clients[1] and clients[1].name or ""
      end,
      icon = icons.lualine.lsp_icon,
    }, { fg = b.magenta, gui = "bold" }, conditions.has_lsp_for_buffer)

    -- arch bookend (tier 1, always)
    H.tier1("right", {
      function()
        return icons.lualine.status_right_arch
      end,
    })

    -- Refresh lualine the instant mini-diff finishes recomputing. Without
    -- this we wait for lualine's next tick (100ms default) — usually fine
    -- but visibly laggy when typing fast. This is fired by mini-diff
    -- after each debounced recompute.
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniDiffUpdated",
      callback = function()
        require("lualine").refresh({ scope = "window", place = { "statusline" } })
      end,
    })

    return config
  end,
}
