local function diff_instructions()
  local diff_id = vim.fn.system("uuidgen"):gsub("\n", "")
  local diff_name = vim.fn.getcwd() .. "/" .. "opencode-" .. diff_id .. ".diff"

  return [[
    Notes about the implementation:

    Instead of modifying any file directly, generate a unified diff containing ONLY the changes you propose.
    Write this diff to a file named `]] .. diff_name .. [[` at the project root.
    The diff must apply cleanly with `git apply ]] .. diff_name .. [[`.
    Do NOT run `git apply` yourself.
    Do NOT modify any other file.

    Only include the minimal necessary changes to solve the task.
    Do NOT touch anything else: all the changes must be localized to the function or block where the comment is.
    If you think the task requires more changes in different places, tell me, but do NOT implement them yet.
  ]], diff_name
end

local function parse_prompt(prompt)
  local path = vim.api.nvim_buf_get_name(0)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local this_ref = path .. ":" .. cursor[1] .. ":" .. cursor[2]
  local diff_prompt, diff_name = diff_instructions()

  prompt = prompt .. "\n\n" .. diff_prompt
  prompt = prompt:gsub("@this", this_ref)
  prompt = prompt:gsub("'", "'\\''")

  return prompt, diff_name
end

local function find_opencode_pane()
  local cmd = [[tmux list-panes -F "#{pane_id} #{pane_current_command}"]]
  local output = vim.fn.systemlist(cmd)

  for _, line in ipairs(output) do
    local pane, process = line:match("^(%%?%d+) (%S+)$")
    if process == "fish" then
      return pane
    end
  end

  vim.notify("No opencode for cwd: " .. vim.fn.getcwd(), vim.log.levels.WARN)
  return nil
end

local function send(pane_id, prompt)
  vim.fn.system(string.format("tmux send-keys -t %s '%s'", pane_id, prompt))
  vim.fn.system(string.format("tmux send-keys -t %s Enter", pane_id))
end

local function apply(bufnr, patch_file)
  vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)

  local result = vim.fn.system(string.format("git apply '%s' 2>&1", patch_file))
  if vim.v.shell_error ~= 0 then
    vim.notify("git apply failed: " .. result, vim.log.levels.ERROR)
    return false
  end

  vim.api.nvim_buf_call(bufnr, function() vim.cmd("checktime") end)
  vim.fn.delete(patch_file)
end

local function poll_diff(bufnr, diff_name, timeout)
  if vim.fn.filereadable(diff_name) == 1 then
    apply(bufnr, diff_name)
    return
  end

  if timeout <= 0 then
    vim.notify("Time out waiting for diff", vim.log.levels.WARN)
    return
  end

  vim.defer_fn(function() poll_diff(bufnr, diff_name, timeout - 500) end, 500)
end

local function feed(raw_prompt)
  local bufnr = vim.api.nvim_get_current_buf()
  local pane_id = find_opencode_pane()
  if not pane_id then return end

  local prompt, diff_name = parse_prompt(raw_prompt)

  vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)
  send(pane_id, prompt)
  poll_diff(bufnr, diff_name, 300000)
end

local function complete()
  local prompt = [[
    @this: Implement the missing code in this function or block.
    If the function or block is completely empty, do your best to fill it with the necessary code based on the signature and context.
    If it's not empty, look for TODO comments within this function or block and follow their instructions.
    If it's not empty, and there are no TODO comments, ask for clarification before doing anything.
    Feel free to look around the code base and infer more details on what's supposed to be done.
  ]]

  feed(prompt)
end

local function ask()
  local prompt = vim.fn.input("Ask Opencode: ")
  if prompt == "" then return end

  feed("@this: " .. prompt)
end

local M = {}

function M.setup()
  vim.keymap.set("n", "<leader>oa", ask)
  vim.keymap.set("n", "<leader>of", complete)
end

return M
