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
