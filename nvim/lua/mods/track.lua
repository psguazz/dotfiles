local f = require("lib.format")
local git = require("lib.git")
local h = require("mods.hook")
local palette = require("lib.palette")

local show = false

local function name_length(n_tabs, show_current)
  local width = vim.o.columns - 5
  if f.tree_open() then width = width - 30 end

  if show_current then
    width = width - 5
    n_tabs = n_tabs + 1
  end

  return math.floor(width / n_tabs) - 9
end

local function tree_bar()
  if not f.tree_open() then return "" end

  local icon = f.format("TablineIcon", "󰙅 ")
  local text = f.format("TablineTitle", "Files")

  return "  " .. icon .. text .. "                     "
end

local function tab(hook, name_limit)
  local status = git.status(hook.path)
  local is_unsaved = f.is_unsaved(hook.path)

  local group = "Tabline"
  if hook.is_current then group = group .. "Selected" end

  local prefix_group = "TablinePrefix"
  if hook.index == " " then prefix_group = prefix_group .. "Temp" end
  if hook.is_perm then prefix_group = prefix_group .. "Pin" end

  local number_group = group .. "Number"

  local name_group = group .. "Name"
  if status ~= "None" then name_group = name_group .. status end

  local prefix = " "
  if hook.is_current then prefix = f.format(prefix_group, "▐") end

  local number = f.format(number_group, " " .. hook.index)
  local icon = " " .. f.colored_icon(hook.path, hook.is_current) .. " "

  local name = vim.fn.fnamemodify(hook.path, ":t")
  if #name > name_limit then name = string.sub(name, 1, name_limit) .. "…" end
  name = f.format(name_group, name)

  local suffix = "  "
  if is_unsaved then suffix = f.format(number_group, "* ") end

  return "%#TablineBackground#" .. prefix .. number .. icon .. name .. suffix .. "%#TablineBackground#"
end

local function tabline()
  local perm_hooks = h.perm_hooks()
  local temp_hooks = h.temp_hooks()

  local current_path = vim.api.nvim_buf_get_name(0)
  local current_name = vim.fn.fnamemodify(current_path, ':.')

  local show_current = not h.current() and current_name ~= "" and current_name ~= "NvimTree_1"
  local name_limit = name_length(#perm_hooks + #temp_hooks, show_current)

  local perm_line = ""
  for _, hook in ipairs(perm_hooks) do
    perm_line = perm_line .. tab(hook, name_limit)
  end

  local temp_line = ""
  for _, hook in ipairs(temp_hooks) do
    temp_line = temp_line .. tab(hook, name_limit)
  end

  local curr_line = ""
  if show_current then
    local fake_hook = { path = current_path, index = " ", is_perm = false, is_current = true }
    curr_line = tab(fake_hook, name_limit)
  end

  local lines = {}
  if #perm_line > 0 then table.insert(lines, perm_line) end
  if #temp_line > 0 then table.insert(lines, temp_line) end
  if #curr_line > 0 then table.insert(lines, curr_line) end

  local divider = f.format("TablineBackground", "  |  ")
  local line = table.concat(lines, divider)

  return "%#TablineBackground#" .. tree_bar() .. line .. "%#TablineBackground#"
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
  vim.api.nvim_set_hl(0, "TablineTitle", { fg = palette.fg, bg = palette.bg_dim })
  vim.api.nvim_set_hl(0, "TablineBackground", { fg = palette.grey, bg = palette.bg_dim })

  vim.api.nvim_set_hl(0, "TablineIcon", { fg = palette.orange, bg = palette.bg_dim })
  vim.api.nvim_set_hl(0, "TablinePrefix", { fg = palette.orange, bg = palette.bg_dim })
  vim.api.nvim_set_hl(0, "TablinePrefixPin", { fg = palette.red, bg = palette.bg_dim })
  vim.api.nvim_set_hl(0, "TablinePrefixTemp", { fg = palette.yellow, bg = palette.bg_dim })
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
