local harpoon = require("harpoon")
local git = require("lib.git")
local devicons = require("nvim-web-devicons")

local function is_unsaved(file_path)
  local buf = vim.fn.bufnr(file_path)

  if buf == -1 then
    return false
  end

  return vim.api.nvim_buf_get_option(buf, "modified")
end

local function format(group, text)
  return "%#" .. group .. "#" .. text
end

local function icon(name, apply_color)
  local icon, icon_color = devicons.get_icon_color(name, vim.fn.fnamemodify(name, ":e"), { default = true })

  if apply_color then
    local group_name = "TabLineColor" .. icon_color:gsub("#", "")
    vim.api.nvim_set_hl(0, group_name, { fg = icon_color })

    return format(group_name, icon)
  else
    return icon
  end
end

function _G.my_tabline()
  local names = harpoon:list():display()
  local current_name = vim.fn.bufname()

  local tabline = ""

  for i, name in ipairs(names) do
    local is_current = string.match(current_name, name .. "$")
    local status = git.status(name)

    local group = "Tabline"
    if is_current then group = group .. "Selected" end

    local number_group = group .. "Number"
    local name_group = group .. "Name"
    if status ~= "None" then name_group = name_group .. status end

    local number = format(number_group, i)
    local icon = icon(name, is_current)
    local tab_name = format(name_group, vim.fn.fnamemodify(name, ":t"))

    local suffix = "  "
    if is_unsaved(name) then suffix = format(number_group, "* ") end

    local tab = "  " .. number .. " " .. icon .. " " .. tab_name .. suffix

    tabline = tabline .. tab
  end

  return "%#TablineBackground#" .. tabline .. "%#TablineBackground#"
end

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    git.refresh()
  end
})

vim.o.tabline = '%!v:lua.my_tabline()'
