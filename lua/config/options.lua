-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.markdown_fenced_languages = { "html", "python", "bash=sh", "R=r" }
vim.opt.termguicolors = true

-- use spaces as tabs
local tabsize = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = tabsize
vim.opt.tabstop = tabsize

--tabline
vim.opt.showtabline = 1

--windowline
vim.opt.winbar = "%t"

--don"t continue comments automagically
vim.opt.formatoptions:remove({ "c", "r", "o" })
