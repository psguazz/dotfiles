local harpoon = require("harpoon")

local git = require("lib.git")
local palette = require("lib.palette")
local f = require("lib.format")

local full = false

local mode_map = {
  n = "Normal",
  no = "Normal",
  v = "Visual",
  V = "V-Line",
  [""] = "V-Block",
  i = "Insert",
  R = "Replace",
  Rv = "V-Replace",
  c = "Command",
  s = "Select",
  S = "S-Line",
  [""] = "S-Block",
  t = "Terminal",
}

local left_pill = ""
local right_pill = ""

local function should_hide()
  local disabled_filetypes = { "NvimTree", "fugitive" }
  local current_ft = vim.bo.filetype

  for _, ft in ipairs(disabled_filetypes) do
    if current_ft == ft then
      return true
    end
  end

  return false
end

local function mode(active, current_mode, big)
  local text = "  "
  if big then text = current_mode end

  local group = "Statusline" .. current_mode .. active
  return f.format(group, left_pill) .. f.format(group .. "Inverted", text) .. f.format(group, right_pill)
end

local function placeholder_line(active, current_mode)
  return mode(active, current_mode, false)
end

local function bare_line(active, current_mode)
  return mode(active, current_mode, false)
end

local function full_line(active, current_mode)
  return mode(active, current_mode, true)
end

function _G.my_statusline()
  local current_mode = mode_map[vim.api.nvim_get_mode().mode] or "Unknown"

  local active = tonumber(vim.g.actual_curwin) == vim.api.nvim_get_current_win()
  active = (active and "Active") or ""

  if should_hide() then
    return placeholder_line(active, current_mode)
  end

  if full then
    return full_line(active, current_mode)
  else
    return bare_line(active, current_mode)
  end
end

vim.api.nvim_create_user_command("S", function()
  if full then
    vim.cmd("Soff")
  else
    vim.cmd("Son")
  end
end, {})

vim.api.nvim_create_user_command("Son", function()
  full = true
end, {})

vim.api.nvim_create_user_command("Soff", function()
  full = false
end, {})

vim.api.nvim_set_hl(0, "StatuslineBackground", { bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "StatuslinePrefix", { fg = palette.red, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "StatuslineNumber", { fg = palette.grey, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "StatuslineName", { fg = palette.grey, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "StatuslineNameModified", { fg = palette.off_yellow, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "StatuslineNameStaged", { fg = palette.off_blue, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "StatuslineNameNew", { fg = palette.off_green, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "StatuslineNameDeleted", { fg = palette.off_red, bg = palette.bg_dim })
vim.api.nvim_set_hl(0, "StatuslineSelectedNumber", { fg = palette.grey, bg = palette.bg0 })
vim.api.nvim_set_hl(0, "StatuslineSelectedName", { fg = palette.fg, bg = palette.bg0 })
vim.api.nvim_set_hl(0, "StatuslineSelectedNameModified", { fg = palette.yellow, bg = palette.bg0 })
vim.api.nvim_set_hl(0, "StatuslineSelectedNameStaged", { fg = palette.blue, bg = palette.bg0 })
vim.api.nvim_set_hl(0, "StatuslineSelectedNameNew", { fg = palette.green, bg = palette.bg0 })
vim.api.nvim_set_hl(0, "StatuslineSelectedNameDeleted", { fg = palette.red, bg = palette.bg0 })

vim.o.statusline = '%!v:lua.my_statusline()'
