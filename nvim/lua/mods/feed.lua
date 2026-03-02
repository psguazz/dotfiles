-- OPENCODE INTEGRATION

local function parse_prompt(prompt, patch_path, marker_path)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local this_ref = patch_path .. ":" .. cursor[1] .. ":" .. cursor[2]

  prompt = prompt .. [[
    When you're done, create an empty file named `]] .. marker_path .. [[`.
  ]]

  prompt = prompt:gsub("@this", this_ref)
  prompt = prompt:gsub("'", "'\\''")

  return prompt
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

-- PATCHING AND PARSING

local function diff_paths()
  local path = vim.api.nvim_buf_get_name(0)
  local ext = vim.fn.fnamemodify(path, ":e")
  local diff_id = vim.fn.system("uuidgen"):gsub("\n", "")

  local snapshot_path = vim.fn.getcwd() .. "/opencode-feed/snapshot-" .. diff_id .. "." .. ext
  local patch_path = vim.fn.getcwd() .. "/opencode-feed/patch-" .. diff_id .. "." .. ext
  local marker_path = vim.fn.getcwd() .. "/opencode-feed/" .. diff_id .. "-done"

  return snapshot_path, patch_path, marker_path
end

local function make_copy(bufnr, dest_path)
  local path = vim.api.nvim_buf_get_name(bufnr)
  vim.fn.system("mkdir -p " .. vim.fn.fnamemodify(dest_path, ":h"))
  vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)
  vim.fn.system("cp " .. path .. " " .. dest_path)
end

local function apply(bufnr, snapshot_path, patch_path, marker_path)
  local current_path = vim.api.nvim_buf_get_name(bufnr)

  vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)
  vim.fn.system("git merge-file --quiet --ours " .. current_path .. " " .. snapshot_path .. " " .. patch_path)

  vim.api.nvim_buf_call(bufnr, function() vim.cmd("checktime") end)
  vim.fn.system("rm " .. snapshot_path)
  vim.fn.system("rm " .. patch_path)
  vim.fn.system("rm " .. marker_path)
end

local function poll_diff(bufnr, snapshot_path, patch_path, marker_path, timeout)
  if vim.fn.filereadable(marker_path) == 1 then
    apply(bufnr, snapshot_path, patch_path, marker_path)
    return
  end

  if timeout <= 0 then
    vim.notify("Time out waiting for diff", vim.log.levels.WARN)
    return
  end

  vim.defer_fn(function() poll_diff(bufnr, snapshot_path, patch_path, marker_path, timeout - 500) end, 500)
end

-- FEEDING

local function feed(raw_prompt)
  local pane_id = find_opencode_pane()
  if not pane_id then return end

  local bufnr = vim.api.nvim_get_current_buf()
  local snapshot_path, patch_path, marker_path = diff_paths()
  local prompt = parse_prompt(raw_prompt, patch_path, marker_path)

  make_copy(bufnr, snapshot_path)
  make_copy(bufnr, patch_path)

  send(pane_id, prompt)
  poll_diff(bufnr, snapshot_path, patch_path, marker_path, 300000)
end

local function complete()
  local prompt = [[
    @this: Implement the missing code in this function or block.
    If the function or block is empty, do your best to fill it with the necessary code based on the signature and context.
    If it's not empty, look for TODO comments within this function or block, delete it, and follow their instructions.
    If it's not empty, and there are no TODO comments, ask for clarification before doing anything.
    Feel free to look around the code base and infer more details on what's supposed to be done.
    When you have a plan, add your code here, and remove whatever placeholder was there before.
    Do NOT touch anything else: all the changes must be localized to the function or block where the comment is.
    If you think the task requires more changes in different places, tell me, but do NOT implement them yet.
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
