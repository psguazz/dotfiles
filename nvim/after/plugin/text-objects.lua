local function select_range(start_row, start_col, end_row, end_col)
  vim.fn.setpos("'<", { 0, start_row + 1, start_col + 1 })
  vim.fn.setpos("'>", { 0, end_row + 1, end_col })
  vim.cmd("normal! gv")
end

-- INDENT OBJECTS

local function current_or_higher_indent(line, base_indent)
  local content = vim.fn.getline(line)
  if content:match("^%s*$") then
    return true
  end
  return vim.fn.indent(line) >= base_indent
end

local function find_start(line, base_indent)
  while line > 1 and current_or_higher_indent(line - 1, base_indent) do
    line = line - 1
  end
  return line
end

local function find_end(line, base_indent, last)
  while line < last and current_or_higher_indent(line + 1, base_indent) do
    line = line + 1
  end
  return line
end

local function select_indent()
  local line = vim.fn.line(".")
  local last = vim.fn.line("$")
  local base_indent = vim.fn.indent(line)

  local start_line = find_start(line, base_indent)
  local end_line = find_end(line, base_indent, last)

  select_range(start_line - 1, 0, end_line - 1, 999)
end

vim.keymap.set({ "x", "o" }, "ii", select_indent, { desc = "inner indent" })
vim.keymap.set({ "x", "o" }, "ai", select_indent, { desc = "around indent" })

-- TREESITTER OBJECTS

local function find_block(node, target_type)
  while node do
    local type = node:type()
    if type == target_type then
      return node
    end
    node = node:parent()
  end
  return nil
end

local function select_around(target_type)
  local node = vim.treesitter.get_node()
  if not node then return end

  local block = find_block(node, target_type)
  if not block then return end

  local srow, scol, erow, ecol = block:range()
  select_range(srow, scol, erow, ecol)
end

local function select_inside(target_type)
  local node = vim.treesitter.get_node()
  if not node then return end

  local block = find_block(node, target_type)
  if not block then return end

  local count = block:child_count()
  if count <= 2 then return end

  local first_child = block:child(1)
  local last_child = block:child(count - 2)

  local srow, scol = first_child:start()
  local erow, ecol = last_child:end_()
  select_range(srow, scol, erow, ecol)
end

vim.keymap.set({ "x", "o" }, "ad", function() select_around("do_block") end, { desc = "around do/end" })
vim.keymap.set({ "x", "o" }, "id", function() select_inside("do_block") end, { desc = "inner do/end" })
