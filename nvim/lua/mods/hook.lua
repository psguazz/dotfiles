-- STATE

local global_limit = 9
local state = {
  current = 1,
  hooked_perm = {},
  hooked_temp = {}
}

local function base_hook()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  local cursor = vim.api.nvim_win_get_cursor(0)

  if path == "" then return nil end

  return {
    path = path,
    cursor = { cursor[1], cursor[2] }
  }
end

local function decorated_hook(hook, is_perm, i)
  return {
    path = hook.path,
    cursor = hook.cursor,
    index = i,
    is_current = i == state.current,
    is_perm = is_perm,
  }
end

local function all_hooks()
  local hooks = {}

  for i, hook in ipairs(state.hooked_perm) do
    table.insert(hooks, decorated_hook(hook, true, i))
  end

  for i, hook in ipairs(state.hooked_temp) do
    table.insert(hooks, decorated_hook(hook, false, i + #state.hooked_perm))
  end

  return hooks
end

-- PRIMITIVES

local function index(list, hook)
  if hook == nil then return nil end

  for i, existing in ipairs(list) do
    if existing.path == hook.path then
      return i
    end
  end
end

local function contains(list, hook)
  return index(list, hook) ~= nil
end

local function remove_hook(list, hook)
  local i = index(list, hook)
  if i then table.remove(list, i) end
end

local function update_hook(list, hook)
  local i = index(list, hook)
  if i then list[i] = hook end
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
  local hooks = all_hooks()
  if not number or number < 1 then number = #hooks end
  if number > #hooks then number = 1 end
  if #hooks == 0 then number = nil end

  state.current = number

  if number ~= nil then
    local hook = hooks[number]
    vim.cmd("edit " .. vim.fn.fnameescape(hook.path))
  end
end

local function restore_hook()
  local hooks = all_hooks()
  state.current = index(hooks, base_hook())

  if hooks[state.current] ~= nil then
    pcall(vim.api.nvim_win_set_cursor, 0, hooks[state.current].cursor)
  end
end

local function go_to_next()
  go_to((state.current or global_limit) + 1)
end

local function go_to_prev()
  go_to((state.current or 0) - 1)
end

-- STATE MANAGEMENT

local function unhook_all()
  state.hooked_perm = {}
  state.hooked_temp = {}
  state.current = nil

  vim.cmd("NvimTreeFocus")

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if not buf_name:match("NvimTree_") then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

local function unhook()
  local hook = base_hook()
  local buf = vim.api.nvim_get_current_buf()

  remove_hook(state.hooked_perm, hook)
  remove_hook(state.hooked_temp, hook)
  go_to_prev()

  if state.current == nil then vim.cmd("NvimTreeFocus") end
  vim.api.nvim_buf_delete(buf, { force = true })
end

local function hook_perm()
  local hook = base_hook()
  if contains(state.hooked_perm, hook) then return end

  remove_hook(state.hooked_temp, hook)

  add_hook(state.hooked_perm, hook, global_limit - 1)
  state.current = #state.hooked_perm
end

local function hook_temp()
  local hook = base_hook()
  if contains(state.hooked_perm, hook) then return end
  if contains(state.hooked_temp, hook) then return end

  add_hook(state.hooked_temp, hook, global_limit - #state.hooked_perm)
  state.current = #state.hooked_perm + #state.hooked_temp
end

local function rehook()
  local hook = base_hook()

  update_hook(state.hooked_perm, hook)
  update_hook(state.hooked_temp, hook)
end

-- SESSION

local function hooks_name()
  local cwd = vim.loop.cwd() or "unknown"
  return vim.fn.sha256(cwd):sub(1, 16) .. ".json"
end

local function hooks_path()
  local hook_dir = vim.fn.stdpath("data") .. "/hooks"
  vim.fn.mkdir(hook_dir, "p")

  local full_path = hook_dir .. "/" .. hooks_name()
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

local M = { all_hooks = all_hooks }

function M.setup()
  vim.api.nvim_create_autocmd("VimLeavePre", { callback = save_hooks })
  vim.api.nvim_create_autocmd("VimEnter", { callback = load_hooks })
  vim.api.nvim_create_autocmd("BufLeave", { callback = rehook })
  vim.api.nvim_create_autocmd("BufEnter", { callback = restore_hook })
  vim.api.nvim_create_autocmd("BufWritePre", { callback = hook_temp })

  vim.api.nvim_create_user_command("A", hook_perm, {})
  vim.api.nvim_create_user_command("Q", unhook, {})
  vim.api.nvim_create_user_command("QA", unhook_all, {})

  for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function() go_to(i) end)
  end

  vim.keymap.set("n", "<leader>,", go_to_prev)
  vim.keymap.set("n", "<leader>.", go_to_next)
end

return M
