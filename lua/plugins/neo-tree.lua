-- neo-tree with filesystem, buffers, git_status, and document_symbols
-- sources;
-- * custom git icons from utils.icons
-- * the lsp rename hook and post-lazygit refresh come from LazyVim's
--   `editor.neo-tree` extra--no `config` here so its `config` still runs

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
}
