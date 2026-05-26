-- neo-tree with filesystem, buffers, git_status, and document_symbols
-- sources;
-- * custom git icons from utils.icons
-- * lsp rename hook keeps
-- imports/references in sync when files are moved or renamed in the tree

local icons = require("utils.icons")

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  opts = {
    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      never_show = { ".DS_Store" },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
    },
    window = {
      mappings = {
        ["<space>"] = "none",
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = icons.neotree.folder.arrow_closed,
        expander_expanded = icons.neotree.folder.arrow_open,
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = icons.neotree.folder.default,
        folder_open = icons.neotree.folder.open,
        folder_empty = icons.neotree.folder.empty,
        default = icons.neotree.folder.default,
      },
      modified = {
        symbol = icons.neotree.file.modified,
      },
      git_status = {
        symbols = {
          added = "", -- intentionally blank: rely on neo-tree's highlight
          modified = "", -- intentionally blank: rely on neo-tree's highlight
          deleted = icons.neotree.git.deleted,
          untracked = icons.neotree.git.untracked,
          ignored = icons.neotree.git.ignored,
          unstaged = icons.neotree.git.unstaged,
          staged = icons.neotree.git.staged,
          conflict = icons.neotree.git.conflict,
        },
      },
    },
  },
  config = function(_, opts)
    local Util = require("lazyvim.util")
    local function on_move(data)
      Util.lsp.on_rename(data.source, data.destination)
    end

    local events = require("neo-tree.events")
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })
    require("neo-tree").setup(opts)

    -- Refresh git_status after lazygit closes so the tree reflects new state.
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,
}
