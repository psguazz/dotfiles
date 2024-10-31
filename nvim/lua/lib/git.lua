local M = {}

local git_cache = {}

function M.status(file_path)
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

function M.refresh()
  git_cache = {}
end

return M
