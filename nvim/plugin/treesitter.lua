vim.pack.add({ "OXY2DEV/markview.nvim" })
vim.pack.add({ src = "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" })

vim.pack.add({
  src = "nvim-treesitter/nvim-treesitter",
  branch = "main",
})

local parsers = {
  "bash",
  "c",
  "cpp",
  "css",
  "dockerfile",
  "eex",
  "elixir",
  "embedded_template",
  "gdscript",
  "gdshader",
  "gitcommit",
  "go",
  "godot_resource",
  "graphql",
  "heex",
  "html",
  "javascript",
  "json",
  "latex",
  "lua",
  "po",
  "prolog",
  "python",
  "ruby",
  "rust",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "zig",
}

for _, parser in ipairs(parsers) do
  require("nvim-treesitter").install(parser)
end

local patterns = {}
for _, parser in ipairs(parsers) do
  local parser_patterns = vim.treesitter.language.get_filetypes(parser)
  for _, pp in pairs(parser_patterns) do
    table.insert(patterns, pp)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = patterns,
  callback = function()
    vim.treesitter.start()
  end,
})

vim.keymap.set({ "x", "o" }, "af", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "as", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
end)

vim.keymap.set("n", "<leader>a", function()
  require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
end)
vim.keymap.set("n", "<leader>A", function()
  require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.outer"
end)
