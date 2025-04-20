local ts = require("telescope.builtin")

local function unique_paths(grep_results)
  local seen = {}
  local unique_list = {}

  for _, result in ipairs(grep_results) do
    local path = result:match("^(.-):%d+:")
    if path and not seen[path] then
      seen[path] = true
      table.insert(unique_list, result)
    end
  end

  return unique_list
end

local function escape(text)
  return vim.fn.escape(text, "/\\")
end

local function current_word()
  return escape(vim.fn.expand("<cword>"))
end

local function current_selection()
  vim.cmd('noau normal! "vy"')
  return escape(vim.fn.getreg("v"))
end

local function search(text)
  vim.fn.setreg("/", "\\V" .. text)
  vim.cmd("normal! n")
  vim.cmd("normal! N")
end

local function global_search(text)
  ts.live_grep({ default_text = text, use_regex = false, })
end

local function replace(text)
  local pos = vim.api.nvim_win_get_cursor(0)
  local replacement = vim.fn.input("Replace " .. text .. " with: ")

  text = "\\V" .. text
  vim.cmd(".,$s/" .. text .. "/" .. replacement .. "/gce")

  vim.api.nvim_win_set_cursor(0, pos)
end

local function global_replace(text)
  local buf = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(0)
  local replacement = vim.fn.input("GLOBAL Replace `" .. text .. "` with: ")

  if #replacement < 1 then return end

  local cmd = { "git", "grep", "-n", "--no-color", text }
  local results = unique_paths(vim.fn.systemlist(cmd))

  if #results < 1 then return end

  text = "\\V" .. text
  vim.fn.setqflist({}, " ", { title = "Global Replace", lines = results })
  vim.cmd("cdo %s/" .. text .. "/" .. replacement .. "/gc")

  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_win_set_cursor(0, pos)
end

local M = {}

function M.setup()
  vim.keymap.set("n", "<C-_>", function() search(current_word()) end, { noremap = true, silent = true })
  vim.keymap.set("v", "<C-_>", function() search(current_selection()) end, { noremap = true, silent = true })

  vim.keymap.set("n", "<C-;>", function() global_search(current_word()) end, { noremap = true, silent = true })
  vim.keymap.set("v", "<C-;>", function() global_search(current_selection()) end, { noremap = true, silent = true })

  vim.keymap.set("n", "<C-n>", function() replace(current_word()) end, { noremap = true, silent = true })
  vim.keymap.set("v", "<C-n>", function() replace(current_selection()) end, { noremap = true, silent = true })

  vim.keymap.set("n", "<C-b>", function() global_replace(current_word()) end, { noremap = true, silent = true })
  vim.keymap.set("v", "<C-b>", function() global_replace(current_selection()) end, { noremap = true, silent = true })
end

return M
