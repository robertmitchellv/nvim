-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local api = vim.api
local cmd = vim.cmd
local opt = vim.opt

-- tell lazyvim what python lsp tooling i want to use
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- color definitions for use in highlights and UI
local colors = {
  -- spelling error squiggles (brightest for visibility)
  spell_bad = "#ff899d", -- red_bright (Tokyo Night Storm)
  spell_cap = "#c7a9ff", -- magenta_bright (Tokyo Night Storm)
  spell_rare = "#faba4a", -- yellow_bright (Tokyo Night Storm)
  spell_local = "#a4daff", -- cyan_bright (Tokyo Night Storm)

  -- gitblame highlights
  gitblame_fg = "#565f89", -- comment (Tokyo Night Storm)
  gitblame_bg = "#292e42", -- bg_highlight (Tokyo Night Storm)
}

api.nvim_create_autocmd("FileType", {
  pattern = {
    "lua",
    "python",
    "json",
    "javascript",
    "typescript",
    "sh",
    "yaml",
    "terraform",
    "markdown",
    "text",
    "gitcommit",
  },
  callback = function()
    vim.wo.spell = true
    vim.bo.spelllang = "en"
  end,
})

-- squiggly underline for spelling errors
cmd(string.format("highlight SpellBad gui=undercurl guisp=%s", colors.spell_bad))
cmd(string.format("highlight SpellCap gui=undercurl guisp=%s", colors.spell_cap))
cmd(string.format("highlight SpellRare gui=undercurl guisp=%s", colors.spell_rare))
cmd(string.format("highlight SpellLocal gui=undercurl guisp=%s", colors.spell_local))

-- GitBlame highlight (italic comment color on bg_highlight)
cmd(
  string.format("highlight GitBlame cterm=italic gui=italic guifg=%s guibg=%s", colors.gitblame_fg, colors.gitblame_bg)
)
cmd("hi link Keyword GitBlame")

-- clipboard integration
opt.clipboard = "unnamedplus"

if vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy --foreground --type text/plain",
      ["*"] = "wl-copy --foreground --type text/plain",
    },
    paste = {
      ["+"] = "wl-paste --no-newline",
      ["*"] = "wl-paste --no-newline",
    },
    cache_enabled = 0,
  }
end
