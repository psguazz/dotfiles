vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set({ "n", "v" }, "<leader>j", "<c-d>zz")
vim.keymap.set({ "n", "v" }, "<leader>k", "<c-u>zz")

vim.keymap.set("n", "<leader>\"", ":split<CR>")
vim.keymap.set("n", "<leader>%", ":vsplit<CR>")

vim.keymap.set("n", "q,", ":cprevious<CR>")
vim.keymap.set("n", "q.", ":cnext<CR>")

vim.keymap.set("n", "<C-o>", ":b#<CR>")

vim.api.nvim_create_user_command("W", "w", {})

vim.api.nvim_create_user_command("CP", function()
  local file_path = vim.fn.expand("%:p")
  vim.fn.setreg("+", file_path)
end, {})
