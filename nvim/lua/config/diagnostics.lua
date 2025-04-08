vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.keymap.set("n", "<leader>d.", "<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>")
vim.keymap.set("n", "<leader>d,", "<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>")

vim.keymap.set("n", "<leader>dd", function()
  require("telescope.builtin").diagnostics()
end)
