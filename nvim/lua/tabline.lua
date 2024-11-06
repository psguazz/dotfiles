local harpoon = require("harpoon")
local devicons = require("nvim-web-devicons")

local git = require("lib.git")
local palette = require("lib.palette")

local hl_groups = {}

local function is_unsaved(file_path)
  local buf = vim.fn.bufnr(file_path)

  if buf == -1 then
    return false
  end

  return vim.api.nvim_buf_get_option(buf, "modified")
end

local function define_group(name, opts)
  if not hl_groups[name] then
    hl_groups[name] = opts
    vim.api.nvim_set_hl(0, name, opts)
  end
end


local function format(group, text)
  return "%#" .. group .. "#" .. text
end

local function colored_icon(name, apply_color)
  local icon, icon_color = devicons.get_icon_color(name, vim.fn.fnamemodify(name, ":e"), { default = true })

  if apply_color then
    local group_name = "TabLineColor" .. icon_color:gsub("#", "")
    define_group(group_name, { fg = icon_color })

    return format(group_name, icon)
  else
    return icon
  end
end

local function tab(name, index, is_current)
  local status = git.status(name)

  local group = "Tabline"
  if is_current then group = group .. "Selected" end

  local number_group = group .. "Number"
  local name_group = group .. "Name"
  if status ~= "None" then name_group = name_group .. status end

  local number = format(number_group, " " .. index)
  local icon = colored_icon(name, is_current)
  local tab_name = format(name_group, vim.fn.fnamemodify(name, ":t"))

  local prefix = " "
  if is_current then prefix = format("TablinePrefix", "▐") end

  local suffix = "  "
  if is_unsaved(name) then suffix = format(number_group, "* ") end

  return "%#TablineBackground#" .. prefix .. number .. " " .. icon .. " " .. tab_name .. suffix
end

function _G.my_tabline()
  local names = harpoon:list():display()
  local current_name = vim.fn.bufname()

  local tabline = ""
  local current_found = false

  for i, name in ipairs(names) do
    local is_current = string.match(current_name, name .. "$")
    tabline = tabline .. tab(name, i, is_current)

    if is_current then
      current_found = true
    end
  end

  if not current_found then
    tabline = tabline .. tab(current_name, " ", true)
  end

  return tabline .. "%#TablineBackground#"
end

vim.api.nvim_set_hl(0, "TablineBackground", { bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "TablinePrefix", { fg = palette.red, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "TablineNumber", { fg = palette.grey, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "TablineName", { fg = palette.grey, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "TablineNameModified", { fg = palette.off_yellow, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "TablineNameStaged", { fg = palette.off_blue, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "TablineNameNew", { fg = palette.off_green, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "TablineNameDeleted", { fg = palette.off_red, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "TablineSelectedNumber", { fg = palette.grey, bg = palette.bg0 })
vim.api.nvim_set_hl(0, "TablineSelectedName", { fg = palette.fg, bg = palette.bg0 })
vim.api.nvim_set_hl(0, "TablineSelectedNameModified", { fg = palette.yellow, bg = palette.bg0 })
vim.api.nvim_set_hl(0, "TablineSelectedNameStaged", { fg = palette.blue, bg = palette.bg0 })
vim.api.nvim_set_hl(0, "TablineSelectedNameNew", { fg = palette.green, bg = palette.bg0 })
vim.api.nvim_set_hl(0, "TablineSelectedNameDeleted", { fg = palette.red, bg = palette.bg0 })

vim.o.tabline = '%!v:lua.my_tabline()'
