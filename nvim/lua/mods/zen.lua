local zen = true

local function zen_on()
  zen = true
  vim.cmd("Toff")
  vim.cmd("Soff")
  vim.cmd("NvimTreeClose")
end

local function zen_off()
  zen = false
  vim.cmd("Ton")
  vim.cmd("Son")
  vim.cmd("NvimTreeOpen")
  vim.cmd("wincmd l")
end

local function zen_toggle()
  if zen then
    zen_off()
  else
    zen_on()
  end
end

local M = {}

function M.setup()
  vim.api.nvim_create_user_command("Zon", zen_on, {})
  vim.api.nvim_create_user_command("Zoff", zen_off, {})
  vim.api.nvim_create_user_command("Z", zen_toggle, {})
end

return M
