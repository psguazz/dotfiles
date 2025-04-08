local f = require("lib.format")
local git = require("lib.git")
local h = require("mods.hook")
local palette = require("lib.palette")

local show = false

local function name_length(n_tabs)
  local width = vim.o.columns
  if f.tree_open() then width = width - 30 end

  return math.floor(width / n_tabs) - 8
end

local function tree_bar()
  if not f.tree_open() then return "" end

  local icon = f.format("TablineIcon", "󰙅 ")
  local text = f.format("TablineBackground", "Files")

  return "  " .. icon .. text .. "                     "
end

local function tab(path, name_limit, index, is_current, is_unsaved, status)
  local group = "Tabline"
  if is_current then group = group .. "Selected" end

  local number_group = group .. "Number"
  local name_group = group .. "Name"
  if status ~= "None" then name_group = name_group .. status end

  local name = vim.fn.fnamemodify(path, ":t")
  if #name > name_limit then name = string.sub(name, 1, name_limit) .. "…" end

  local number = f.format(number_group, " " .. index)
  local icon = f.colored_icon(path, is_current)
  local tab_name = f.format(name_group, name)

  local prefix = " "
  if is_current then prefix = f.format("TablinePrefix", "▐") end

  local suffix = "  "
  if is_unsaved then suffix = f.format(number_group, "* ") end

  return "%#TablineBackground#" .. prefix .. number .. " " .. icon .. " " .. tab_name .. suffix .. "%#TablineBackground#"
end

local function tabline()
  local hooks = h.all_hooks()
  local current_path = vim.api.nvim_buf_get_name(0)
  local current_name = vim.fn.fnamemodify(current_path, ':.')

  local line = tree_bar()
  local name_limit = name_length(#hooks + 1)
  local current_found = false

  for i, hook in ipairs(hooks) do
    local status = git.status(hook.path)
    local is_current = current_path == hook.path
    local is_saved = f.is_unsaved(hook.path)
    line = line .. tab(hook.path, name_limit, i, is_current, is_saved, status)

    if is_current then
      current_found = true
    end
  end

  if not current_found and current_name ~= "" and current_name ~= "NvimTree_1" then
    local current_status = git.status(vim.fn.bufname())
    local is_saved = f.is_unsaved(current_path)
    line = line .. tab(current_path, name_limit, " ", true, is_saved, current_status)
  end

  return "%#TablineBackground#" .. line .. "%#TablineBackground#"
end

local function show_line()
  show = true
  vim.cmd("set showtabline=2")
end

local function hide_line()
  show = false
  vim.cmd("set showtabline=0")
end

local function toggle_line()
  if show then
    hide_line()
  else
    show_line()
  end
end

local M = {}

function M.setup()
  show = not show
  toggle_line()

  vim.api.nvim_create_user_command("T", toggle_line, {})
  vim.api.nvim_create_user_command("Ton", show_line, {})
  vim.api.nvim_create_user_command("Toff", hide_line, {})

  vim.api.nvim_set_hl(0, "Tabline", { fg = "none", bg = "none" })
  vim.api.nvim_set_hl(0, "TablineSel", { fg = "none", bg = "none" })
  vim.api.nvim_set_hl(0, "TablineFill", { fg = "none", bg = "none" })
  vim.api.nvim_set_hl(0, "TablineBackground", { fg = palette.fg, bg = palette.bg_dim })

  vim.api.nvim_set_hl(0, "TablineIcon", { fg = palette.orange, bg = palette.bg_dim })
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

  _G.my_tabline = tabline
  vim.o.tabline = '%!v:lua.my_tabline()'
end

return M
