-- STATE

local global_limit = 9
local state = {
  current = nil,
  hooked_perm = {},
  hooked_writ = {},
  hooked_read = {},
}

local function current()
  return state.current
end

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

local function decorated_hook(hook, status, i)
  return {
    path = hook.path,
    cursor = hook.cursor,
    index = i,
    is_current = i == state.current,
    status = status
  }
end

local function decorate(list, base_index, status)
  local hooks = {}

  for i, hook in ipairs(list) do
    local index = i + base_index
    table.insert(hooks, decorated_hook(hook, status, index))
  end

  return hooks
end

local function perm_hooks()
  local base_index = 0
  return decorate(state.hooked_perm, base_index, 0)
end

local function writ_hooks()
  local base_index = #state.hooked_perm
  return decorate(state.hooked_writ, base_index, 1)
end

local function read_hooks()
  local base_index = #state.hooked_perm + #state.hooked_writ
  return decorate(state.hooked_read, base_index, 2)
end

local function all_hooks()
  local hooks = {}

  for _, hook in ipairs(perm_hooks()) do table.insert(hooks, hook) end
  for _, hook in ipairs(writ_hooks()) do table.insert(hooks, hook) end
  for _, hook in ipairs(read_hooks()) do table.insert(hooks, hook) end

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

local function add_hook(list, hook)
  if hook == nil then return end
  if hook.path:match("NvimTree_") then return end

  remove_hook(list, hook)
  table.insert(list, hook)
end

local function trim(list, limit)
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
  state.hooked_writ = {}
  state.hooked_read = {}
  state.current = nil

  vim.cmd("NvimTreeFocus")

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if not buf_name:match("NvimTree_") then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

local function trim_hooks()
  local limit = global_limit
  trim(state.hooked_perm, limit)

  limit = limit - #state.hooked_perm
  trim(state.hooked_writ, limit)

  limit = limit - #state.hooked_writ
  trim(state.hooked_read, limit)
end

local function unhook()
  local hook = base_hook()
  local buf = vim.api.nvim_get_current_buf()

  remove_hook(state.hooked_perm, hook)
  remove_hook(state.hooked_writ, hook)
  remove_hook(state.hooked_read, hook)
  go_to_prev()

  if state.current == nil then vim.cmd("NvimTreeFocus") end
  vim.api.nvim_buf_delete(buf, { force = true })
end

local function hook_perm()
  local hook = base_hook()

  add_hook(state.hooked_perm, hook)
  remove_hook(state.hooked_writ, hook)
  remove_hook(state.hooked_read, hook)
  trim_hooks()

  state.current = #state.hooked_perm
end

local function hook_writ()
  local hook = base_hook()

  if contains(state.hooked_perm, hook) then return end
  if contains(state.hooked_writ, hook) then return end

  add_hook(state.hooked_writ, hook)
  remove_hook(state.hooked_read, hook)
  trim_hooks()

  state.current = #state.hooked_perm + #state.hooked_writ
end

local function hook_read()
  local hook = base_hook()

  if contains(state.hooked_perm, hook) then return end
  if contains(state.hooked_writ, hook) then return end
  if contains(state.hooked_read, hook) then return end

  add_hook(state.hooked_read, hook)
  trim_hooks()
end

local function rehook()
  local hook = base_hook()

  update_hook(state.hooked_perm, hook)
  update_hook(state.hooked_writ, hook)
  update_hook(state.hooked_read, hook)
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

M = {
  perm_hooks = perm_hooks,
  writ_hooks = writ_hooks,
  read_hooks = read_hooks,
  all_hooks = all_hooks,
  current = current
}

function M.setup()
  vim.api.nvim_create_autocmd("VimLeavePre", { callback = save_hooks })
  vim.api.nvim_create_autocmd("VimEnter", { callback = load_hooks })
  vim.api.nvim_create_autocmd("BufLeave", { callback = rehook })
  vim.api.nvim_create_autocmd("BufEnter", { callback = hook_read })
  vim.api.nvim_create_autocmd("BufEnter", { callback = restore_hook })
  vim.api.nvim_create_autocmd("BufWritePre", { callback = hook_writ })

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
