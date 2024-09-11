vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>j", "<c-d>zz")
vim.keymap.set("n", "<leader>k", "<c-u>zz")

vim.api.nvim_create_user_command("QA", function()
  vim.cmd "%bd|e#|bd#"
end, {})

vim.api.nvim_create_user_command("CP", function()
  local file_path = vim.fn.expand('%:p')
  vim.fn.setreg('+', file_path)
end, {})
