local current_pattern = nil

local function escape(text)
  return vim.fn.escape(text, "/\\")
end

local function feed(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "x", false)
end

local function input(keys)
  vim.api.nvim_input(keys)
end

local function move(count, dir)
  if count < 1 then return end
  input(count .. dir)
end

local function current_selection()
  local start = vim.fn.getpos("'<")
  local finish = vim.fn.getpos("'>")

  if start[2] ~= finish[2] then return end

  vim.cmd('noau normal! "vy"')
  return escape(vim.fn.getreg("v"))
end

local function new_selection()
  vim.cmd("normal! viw")
  return current_selection()
end

local function add_cursor(get_selection)
  if current_pattern == nil then current_pattern = get_selection() end
  if current_pattern == nil then return end

  local n = #current_pattern - 1
  local mode = vim.api.nvim_get_mode().mode

  if mode ~= "n" then feed("<Esc>") end
  feed("2q=")

  vim.fn.setreg("/", "\\V" .. current_pattern)
  move(n, "l")

  input("Q")
  input("n")
  input(" l")

  input("2q=")
  move(n, "l")
  input("1q=")
  move(n, "h")
  input("v")
  move(n, "l")
end

local function clear_cursors()
  local mc_ns = vim.api.nvim_create_namespace('nvim.multicursor')
  vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
  current_pattern = nil
end

local M = {}

function M.setup()
  vim.keymap.set("n", "<C-n>", function() add_cursor(new_selection) end, { noremap = true, silent = true })
  vim.keymap.set("v", "<C-n>", function() add_cursor(current_selection) end, { noremap = true, silent = true })

  vim.keymap.set("n", "<Esc>", clear_cursors)
end

return M
