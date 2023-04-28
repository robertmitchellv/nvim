local icons = {
  default = " ",
  symlink = " ",
  bookmark = " ",
  folder = {
    arrow_closed = " ",
    arrow_open = " ",
    default = " ",
    open = " ",
    empty = " ",
    closed = " ",
    empty_open = " ",
    symlink = " ",
    symlink_open = " ",
    symlink_arrow = "  ",
  },
  file = {
    modified = "󱇨 ",
  },
  git = {
    unstaged = " ",
    staged = " ",
    unmerged = " ",
    renamed = " ",
    untracked = " ",
    deleted = " ",
    ignored = " ",
    conflict = " ",
  },
}

return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
      end,
      desc = "Explorer NeoTree (root dir)",
    },
    {
      "<leader>fE",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("neo-tree")
      end
    end
  end,
  opts = {
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = true,
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
      never_show = {
        ".DS_Store",
      },
    },
    window = {
      mappings = {
        ["<space>"] = "none",
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = icons.folder.arrow_closed,
        expander_expanded = icons.folder.arrow_open,
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = icons.folder.default,
        folder_open = icons.folder.open,
        folder_empty = icons.folder.empty,
        default = icons.folder.default,
      },
      modified = {
        symbol = icons.file.modified,
      },
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = icons.git.deleted,
          untracked = icons.git.untracked,
          ignored = icons.git.ignored,
          unstaged = icons.git.unstaged,
          staged = icons.git.staged,
          conflict = icons.git.conflict,
        },
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)
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
