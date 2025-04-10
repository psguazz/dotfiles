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
require("mods.mend").setup()
require("mods.nest").setup()
require("mods.seek").setup()
require("mods.track").setup()
require("mods.zen").setup()
