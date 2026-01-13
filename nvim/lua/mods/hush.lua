local hush = true

local function hush_on()
  hush = true
  vim.cmd("Toff")
  vim.cmd("Soff")
  vim.cmd("NvimTreeClose")
end

local function hush_off()
  hush = false
  vim.cmd("Ton")
  vim.cmd("Son")
  vim.cmd("NvimTreeOpen")
  vim.cmd("wincmd l")
end

local function hush_toggle()
  if hush then
    hush_off()
  else
    hush_on()
  end
end

local M = {}

function M.setup()
  vim.api.nvim_create_user_command("Zon", hush_on, {})
  vim.api.nvim_create_user_command("Zoff", hush_off, {})
  vim.api.nvim_create_user_command("Z", hush_toggle, {})
end

return M
