local harpoon = require("harpoon")

local git = require("lib.git")
local palette = require("lib.palette")
local f = require("lib.format")

local function tab(name, index, is_current, is_unsaved, status)
  local group = "Tabline"
  if is_current then group = group .. "Selected" end

  local number_group = group .. "Number"
  local name_group = group .. "Name"
  if status ~= "None" then name_group = name_group .. status end

  local number = f.format(number_group, " " .. index)
  local icon = f.colored_icon(name, is_current)
  local tab_name = f.format(name_group, vim.fn.fnamemodify(name, ":t"))

  local prefix = " "
  if is_current then prefix = f.format("TablinePrefix", "▐") end

  local suffix = "  "
  if is_unsaved then suffix = f.format(number_group, "* ") end

  return "%#TablineBackground#" .. prefix .. number .. " " .. icon .. " " .. tab_name .. suffix .. "%#TablineBackground#"
end

function _G.my_tabline()
  local names = harpoon:list():display()
  local current_name = vim.fn.fnamemodify(vim.fn.bufname(), ':.')

  local tabline = ""
  local current_found = false

  for i, name in ipairs(names) do
    local status = git.status(name)
    local is_current = current_name == name
    local is_saved = f.is_unsaved(name)
    tabline = tabline .. tab(name, i, is_current, is_saved, status)

    if is_current then
      current_found = true
    end
  end

  if not current_found and current_name ~= "" and current_name ~= "NvimTree_1" then
    local current_status = git.status(vim.fn.bufname())
    local is_saved = f.is_unsaved(current_name)
    tabline = tabline .. tab(current_name, " ", true, is_saved, current_status)
  end

  return tabline
end

local show = false

vim.api.nvim_create_user_command("T", function()
  if show then
    vim.cmd("Toff")
  else
    vim.cmd("Ton")
  end
end, {})

vim.api.nvim_create_user_command("Ton", function()
  show = true
  vim.cmd("set showtabline=2")
end, {})

vim.api.nvim_create_user_command("Toff", function()
  show = false
  vim.cmd("set showtabline=0")
end, {})

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
