local M = {}

function M.status(file_path)
  local output = vim.fn.systemlist("git status --porcelain " .. vim.fn.shellescape(file_path))

  if not output or #output == 0 then
    return ""
  end

  local status_char = output[1]:sub(2, 2)

  if status_char == "M" then
    return "Modified"
  elseif status_char == "A" then
    return "Staged"
  elseif status_char == "?" then
    return "New"
  elseif status_char == "D" then
    return "Deleted"
  else
    return ""
  end
end

return M
