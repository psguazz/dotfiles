local function session_name()
  local cwd = vim.loop.cwd() or "unknown"
  return vim.fn.sha256(cwd):sub(1, 16) .. ".vim"
end

local function session_path()
  local session_dir = vim.fn.stdpath("data") .. "/sessions"
  vim.fn.mkdir(session_dir, "p")

  local full_path = session_dir .. "/" .. session_name()
  return vim.fn.fnameescape(full_path)
end

local function save_session()
  vim.cmd("NvimTreeClose")
  vim.cmd("mks! " .. session_path())
end

local function load_session()
  if vim.fn.filereadable(session_path()) == 0 then return end

  vim.schedule(function()
    vim.cmd("silent source " .. session_path())
  end)
end

local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("VimLeavePre", { callback = save_session })
  vim.api.nvim_create_autocmd("VimEnter", { callback = load_session })
end

return M
