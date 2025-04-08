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

require("config.diagnostics")
require("config.lsp")
require("config.mappings")
require("config.theme")

require("mods.echo").setup()
require("mods.hook").setup()
require("mods.mend").setup()
require("mods.nest").setup()
require("mods.seek").setup()
require("mods.track").setup()
require("mods.zen").setup()
