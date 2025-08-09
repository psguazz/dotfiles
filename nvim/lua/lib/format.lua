local M = {}

local devicons = require("nvim-web-devicons")
local hl_groups = {}

function M.is_unsaved(file_path)
  local buf = vim.fn.bufnr(file_path)

  if buf == -1 then
    return false
  end

  return vim.api.nvim_buf_get_option(buf, "modified")
end

function M.define_group(name, opts)
  name = name:gsub("-", "")

  if not hl_groups[name] then
    hl_groups[name] = opts
    vim.api.nvim_set_hl(0, name, {})
    vim.api.nvim_set_hl(0, name, opts)
  end
end

function M.format(group, text)
  return "%#" .. group .. "#" .. text
end

function M.icon_and_color(name)
  local icon, icon_color = devicons.get_icon_color(name, vim.fn.fnamemodify(name, ":e"), { default = true })
  local icon_group = "DevIconColor" .. icon_color:gsub("#", "")
  M.define_group(icon_group, { fg = icon_color })

  return icon, icon_group
end

function M.colored_icon(name, apply_color)
  local icon, icon_group = M.icon_and_color(name)

  if apply_color then
    return M.format(icon_group, icon)
  else
    return icon
  end
end

function M.tree_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if bufname:match("NvimTree_") then
      return true
    end
  end

  return false
end

return M
