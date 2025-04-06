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

function M.colored_icon(name, bg_color)
  local icon, icon_color = devicons.get_icon_color(name, vim.fn.fnamemodify(name, ":e"), { default = true })

  if bg_color then
    local group_name = "DevIconColor" .. icon_color:gsub("#", "")
    M.define_group(group_name, { fg = icon_color, bg = bg_color })

    return M.format(group_name, icon)
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
