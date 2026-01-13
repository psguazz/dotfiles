vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.opts")
require("config.lazy")

require("config.diagnostics")
require("config.lsp")
require("config.mappings")
require("config.theme")

require("mods.echo").setup()
require("mods.hook").setup()
require("mods.hush").setup()
require("mods.iron").setup()
require("mods.jump").setup()
require("mods.nest").setup()
require("mods.peek").setup()
require("mods.rail").setup()
require("mods.seek").setup()
