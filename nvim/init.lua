vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.opts")
require("config.lazy")

require("config.diagnostics")
require("config.lsp")
require("config.mappings")
require("config.theme")
require("config.text-objects")

require("config.mods")
