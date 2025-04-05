-- STATE

local state = {
  current = 1,
  hooked_perm = {},
  hooked_temp = {}
}

local function all_hooks()
  local hooks = {}

  for _, hook in ipairs(state.hooked_perm) do
    table.insert(hooks, hook)
  end

  for _, hook in ipairs(state.hooked_temp) do
    table.insert(hooks, hook)
  end

  return hooks
end

-- PRIMITIVES

local function hookified_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(bufnr)
  local cursor = vim.api.nvim_win_get_cursor(0)

  if path == "" then
    return nil
  end

  return {
    path = path,
    cursor = { cursor[1], cursor[2] }
  }
end

local function same_hook(h1, h2)
  return h1.path == h2.path
end

local function index(list, hook)
  if hook == nil then return -1 end

  for i, existing in ipairs(list) do
    if same_hook(existing, hook) then
      return i
    end
  end
  return -1
end

local function contains(list, hook)
  return index(list, hook) >= 0
end

local function find(list, hook)
  local i = index(list, hook)
  if i > 0 then
    return list[i]
  else
    return nil
  end
end

local function remove_hook(list, hook)
  if hook == nil then return end

  local i = index(list, hook)
  if i >= 0 then
    table.remove(list, i)
  end
end

local function update_hook(list, hook)
  local i = index(list, hook)
  if i >= 0 then
    list[i] = hook
  end
end

local function add_hook(list, hook, limit)
  if hook == nil then return end
  if contains(list, hook) then return end

  table.insert(list, hook)

  while #list > (limit or 1000) do
    table.remove(list, 1)
  end
end

-- NAVIGATION

local function go_to(number)
  local hook = all_hooks()[number]
  if hook == nil then return end

  state.current = number
  vim.cmd("edit " .. vim.fn.fnameescape(hook.path))
end

local function restore_cursor()
  local hook = hookified_buffer()
  hook = find(state.hooked_perm, hook) or find(state.hooked_temp, hook)
  if hook == nil then return end

  pcall(vim.api.nvim_win_set_cursor, 0, hook.cursor)
end

local function go_to_next()
  if state.current >= #state.hooked_perm + #state.hooked_temp then
    go_to(1)
  else
    go_to(state.current + 1)
  end
end

local function go_to_prev()
  if state.current <= 1 then
    go_to(#state.hooked_perm + #state.hooked_temp)
  else
    go_to(state.current - 1)
  end
end

-- STATE MANAGEMENT

local function unhook_all()
  state.hooked_perm = {}
  state.hooked_temp = {}

  vim.cmd("NvimTreeFocus")

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if not buf_name:match("NvimTree_1$") then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

local function unhook()
  local hook = hookified_buffer()
  remove_hook(state.hooked_perm, hook)
  remove_hook(state.hooked_temp, hook)
  vim.cmd("bd!")
  go_to_prev()
end


local function hook_perm()
  local hook = hookified_buffer()

  remove_hook(state.hooked_temp, hook)

  add_hook(state.hooked_perm, hook, 8)
  state.current = #state.hooked_perm
end

local function hook_temp()
  local hook = hookified_buffer()

  if contains(state.hooked_perm, hook) then return end

  add_hook(state.hooked_temp, hook, 9 - #state.hooked_perm)
  state.current = #state.hooked_perm + #state.hooked_temp
end

local function rehook()
  local hook = hookified_buffer()

  update_hook(state.hooked_perm, hook)
  update_hook(state.hooked_temp, hook)
end

-- SESSION

local function hooks_name()
  local cwd = vim.loop.cwd() or "unknown"
  return vim.fn.sha256(cwd):sub(1, 16) .. ".json"
end

local function hooks_path()
  local session_dir = vim.fn.stdpath("data") .. "/hooks"
  vim.fn.mkdir(session_dir, "p")

  local full_path = session_dir .. "/" .. hooks_name()
  return vim.fn.fnameescape(full_path)
end


local function save_hooks()
  local json = vim.fn.json_encode(state)
  vim.fn.writefile({ json }, hooks_path())
end

local function load_hooks()
  if vim.fn.filereadable(hooks_path()) == 0 then return end

  local lines = vim.fn.readfile(hooks_path())
  if not lines or #lines == 0 then return end

  local ok, data = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
  if not ok or type(data) ~= "table" then return end

  state = data
end

-- SETUP

local M = {}

M.all_hooks = all_hooks

function M.setup()
  vim.api.nvim_create_autocmd("VimLeavePre", { callback = save_hooks })
  vim.api.nvim_create_autocmd("VimEnter", { callback = load_hooks })
  vim.api.nvim_create_autocmd("BufLeave", { callback = rehook })
  vim.api.nvim_create_autocmd("BufEnter", { callback = restore_cursor })
  vim.api.nvim_create_autocmd("BufWritePre", { callback = hook_temp })

  vim.api.nvim_create_user_command("A", hook_perm, {})
  vim.api.nvim_create_user_command("Q", unhook, {})
  vim.api.nvim_create_user_command("QA", unhook_all, {})

  vim.keymap.set("n", "<leader>1", function() go_to(1) end)
  vim.keymap.set("n", "<leader>2", function() go_to(2) end)
  vim.keymap.set("n", "<leader>3", function() go_to(3) end)
  vim.keymap.set("n", "<leader>4", function() go_to(4) end)
  vim.keymap.set("n", "<leader>5", function() go_to(5) end)
  vim.keymap.set("n", "<leader>6", function() go_to(6) end)
  vim.keymap.set("n", "<leader>7", function() go_to(7) end)
  vim.keymap.set("n", "<leader>8", function() go_to(8) end)
  vim.keymap.set("n", "<leader>9", function() go_to(9) end)

  vim.keymap.set("n", "<leader>,", go_to_prev)
  vim.keymap.set("n", "<leader>.", go_to_next)
end

return M
