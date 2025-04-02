vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>j", "<c-d>zz")
vim.keymap.set("n", "<leader>k", "<c-u>zz")

vim.keymap.set("n", "<leader>\"", ":split<CR>")
vim.keymap.set("n", "<leader>%", ":vsplit<CR>")

vim.keymap.set("n", "<leader>d.", "<cmd>lua vim.diagnostic.goto_next({ float = false })<CR>")
vim.keymap.set("n", "<leader>d,", "<cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>")

vim.api.nvim_create_user_command("Note", "ObsidianNew", {})
vim.api.nvim_create_user_command("Notes", "ObsidianQuickSwitch", {})

vim.api.nvim_create_user_command("CP", function()
  local file_path = vim.fn.expand("%:p")
  vim.fn.setreg("+", file_path)
end, {})

-- Home made Zen mode

local zen = true

vim.api.nvim_create_user_command("Zon", function()
  zen = true
  vim.cmd("Toff")
  vim.cmd("NvimTreeClose")
end, {})

vim.api.nvim_create_user_command("Zoff", function()
  zen = false
  vim.cmd("Ton")
  vim.cmd("NvimTreeOpen")
  vim.cmd("wincmd l")
end, {})

vim.api.nvim_create_user_command("Z", function()
  if zen then
    vim.cmd("Zoff")
  else
    vim.cmd("Zon")
  end
end, {})

-- Multi-cursor replacement

local function replace(text)
  local replacement = vim.fn.input("Replace `" .. text .. "` with: ")
  if replacement ~= "" then
    vim.cmd("%s/" .. text .. "/" .. replacement .. "/gc")
  end
end

vim.keymap.set("n", "<C-n>", function()
  local word = vim.fn.expand("<cword>")
  replace(word)
end, { noremap = true, silent = true })

vim.keymap.set("v", "<C-n>", function()
  vim.cmd('noau normal! "vy"')
  local selected_text = vim.fn.getreg("v")
  replace(selected_text)
end, { noremap = true, silent = true })
