vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>j", "<c-d>zz")
vim.keymap.set("n", "<leader>k", "<c-u>zz")

vim.keymap.set("n", "<leader>\"", ":split<CR>")
vim.keymap.set("n", "<leader>%", ":vsplit<CR>")

vim.keymap.set("n", "<leader>d.", "<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>")
vim.keymap.set("n", "<leader>d,", "<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>")

local zen = false

vim.api.nvim_create_user_command("QA", function()
  vim.cmd "%bd|e#|bd#|'\""
  if not zen then
    vim.cmd("NvimTreeOpen")
    vim.cmd("wincmd l")
  end
end, {})

vim.api.nvim_create_user_command("CP", function()
  local file_path = vim.fn.expand("%:p")
  vim.fn.setreg("+", file_path)
end, {})

vim.api.nvim_create_user_command("Z", function()
  if zen then
    zen = false
    vim.cmd('set showtabline=2')
    vim.cmd("Neominimap on")
    vim.cmd("NvimTreeOpen")
    vim.cmd("wincmd l")
  else
    zen = true
    vim.cmd('set showtabline=0')
    vim.cmd("Neominimap off")
    vim.cmd("NvimTreeClose")
  end
end, {})
