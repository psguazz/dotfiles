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
