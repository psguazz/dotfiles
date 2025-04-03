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
  vim.cmd("Soff")
  vim.cmd("NvimTreeClose")
end, {})

vim.api.nvim_create_user_command("Zoff", function()
  zen = false
  vim.cmd("Ton")
  vim.cmd("Son")
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

-- Quick search/replace in file

local function current_word()
  return vim.fn.expand("<cword>")
end

local function current_selection()
  vim.cmd('noau normal! "vy"')
  return vim.fn.getreg("v")
end

local function replace(text)
  local replacement = vim.fn.input("Replace `" .. text .. "` with: ")
  if replacement ~= "" then
    text = "\\V" .. vim.fn.escape(text, "\\")
    vim.cmd(".,$s/" .. text .. "/" .. replacement .. "/gc")
  end
end

local function search(text)
  vim.fn.setreg("/", "\\V" .. vim.fn.escape(text, "\\"))
  vim.cmd("normal! n")
  vim.cmd("normal! N")
end

vim.keymap.set("n", "<C-n>", function() replace(current_word()) end, { noremap = true, silent = true })
vim.keymap.set("v", "<C-n>", function() replace(current_selection()) end, { noremap = true, silent = true })

vim.keymap.set("n", "<C-_>", function() search(current_word()) end, { noremap = true, silent = true })
vim.keymap.set("v", "<C-_>", function() search(current_selection()) end, { noremap = true, silent = true })
