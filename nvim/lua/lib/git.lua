local M = {}

local git_cache = {}
local cached_at = vim.loop.now()

function M.clear_cache()
  git_cache = {}
  cached_at = vim.loop.now()
end

function M.status(file_path)
  if vim.loop.now() > cached_at + 10000 then
    M.clear_cache()
  end

  if git_cache[file_path] then
    return git_cache[file_path]
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

  git_cache[file_path] = status
  return status
end

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    M.clear_cache()
  end
})

return M
