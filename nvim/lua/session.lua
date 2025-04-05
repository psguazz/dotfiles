local function session_name()
  local cwd = vim.loop.cwd() or "unknown"
  return vim.fn.sha256(cwd):sub(1, 16) .. ".vim"
end

local function session_path()
  local session_dir = vim.fn.stdpath("data") .. "/sessions"
  vim.fn.mkdir(session_dir, "p") -- make sure it exists

  local full_path = session_dir .. "/" .. session_name()
  return vim.fn.fnameescape(full_path)
end

local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      vim.cmd("NvimTreeClose")
      vim.cmd("mks! " .. session_path())
    end
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.schedule(function()
        vim.cmd("silent source " .. session_path())
      end)
    end
  })
end

return M
