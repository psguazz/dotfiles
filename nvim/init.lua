vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.opts")

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" }
}, {})

require("config.lsp")
require("config.mappings")
require("config.theme")

require("mods.seek").setup()
require("mods.zen").setup()
require("mods.tabline").setup()
require("mods.statusline").setup()
require("mods.session").setup()
require("mods.hook").setup()
