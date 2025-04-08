local branch_cache = nil
local status_cache = {}
local cached_at = vim.loop.now()

local function clear_cache()
  branch_cache = nil
  status_cache = {}
  cached_at = vim.loop.now()
end

local function maybe_clear_cache()
  if vim.loop.now() > cached_at + 10000 then
    clear_cache()
  end
end


local M = {}

function M.branch()
  maybe_clear_cache()

  if branch_cache then
    return branch_cache
  end

  local output = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")

  if not output[1] or output[1]:match("^fatal:") then
    branch_cache = ""
  else
    branch_cache = output[1]
  end

  return branch_cache
end

function M.status(file_path)
  maybe_clear_cache()

  if status_cache[file_path] then
    return status_cache[file_path]
  end

  local output = vim.fn.systemlist("git status --porcelain " .. vim.fn.shellescape(file_path))
  local status = "None"

  if #output > 0 then
    local status_char = output[1]:sub(2, 2)

    if status_char == "M" then
      status = "Modified"
    elseif status_char == "A" then
      status = "Staged"
    elseif status_char == "?" then
      status = "New"
    elseif status_char == "D" then
      status = "Deleted"
    end
  end

  status_cache[file_path] = status
  return status
end

vim.api.nvim_create_autocmd("BufWritePost", { callback = clear_cache })

return M
