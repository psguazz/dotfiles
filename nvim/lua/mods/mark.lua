local current_pattern = nil

local function input(keys)
  vim.api.nvim_input(keys)
end

local function move(count, dir)
  if count < 1 then return end
  input(count .. dir)
end

local function current_selection()
  local start = vim.fn.getpos("v")
  local finish = vim.fn.getpos(".")

  if start[2] ~= finish[2] then return end

  local line = start[2] - 1
  local scol = start[3] - 1
  local ecol = finish[3]
  local text = vim.api.nvim_buf_get_text(0, line, scol, line, ecol, {})[1]

  return vim.fn.escape(text, "/\\")
end

local function add_cursor()
  if current_pattern == nil then current_pattern = current_selection() end
  if current_pattern == nil then return end

  local n = #current_pattern - 1

  input("<Esc>")
  input("Q")
  input("/\\V" .. current_pattern .. "<CR>")
  input(":noh<CR>")

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
  vim.keymap.set("n", "<C-n>", function() input("viw") end, { noremap = true, silent = true })
  vim.keymap.set("v", "<C-n>", function() add_cursor() end, { noremap = true, silent = true })

  vim.keymap.set("n", "<Esc>", clear_cursors)
end

return M
