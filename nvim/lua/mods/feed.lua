local POLL_INTERVAL = 500
local TIMEOUT_MS = 300000

-- OPENCODE UTILS

local function parse_prompt(prompt, this_path, marker_path)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local this_ref = string.format("%s:%d:%d", this_path, cursor[1], cursor[2])

  if marker_path then
    prompt = prompt .. string.format([[
      When you're done, create an empty file named `%s`.
    ]], marker_path)
  end

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

local function send_to_pane(pane_id, prompt)
  vim.fn.system(string.format("tmux send-keys -t %s '%s'", pane_id, prompt))
  vim.fn.system(string.format("tmux send-keys -t %s Enter", pane_id))
end

local function send_prompt(prompt)
  local pane_id = find_opencode_pane()
  if not pane_id then return end

  send_to_pane(pane_id, prompt)
end

-- FILE OPERATIONS

local function generate_diff_paths()
  local path = vim.api.nvim_buf_get_name(0)
  local ext = vim.fn.fnamemodify(path, ":e")
  local diff_id = vim.fn.system("uuidgen"):gsub("\n", "")
  local cwd = vim.fn.getcwd()

  local snapshot_path = string.format("%s/opencode-feed/snapshot-%s.%s", cwd, diff_id, ext)
  local patch_path = string.format("%s/opencode-feed/patch-%s.%s", cwd, diff_id, ext)
  local marker_path = string.format("%s/opencode-feed/%s-done", cwd, diff_id)

  return snapshot_path, patch_path, marker_path
end

local function copy_buffer(bufnr, dest_path)
  local path = vim.api.nvim_buf_get_name(bufnr)
  vim.fn.system(string.format("mkdir -p '%s'", vim.fn.fnamemodify(dest_path, ":h")))
  vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)
  vim.fn.system(string.format("cp '%s' '%s'", path, dest_path))
end

local function apply_patch(bufnr, snapshot_path, patch_path, marker_path)
  local current_path = vim.api.nvim_buf_get_name(bufnr)

  vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)
  vim.fn.system(string.format(
    "git merge-file '%s' '%s' '%s'",
    current_path, snapshot_path, patch_path
  ))

  vim.api.nvim_buf_call(bufnr, function() vim.cmd("checktime") end)

  vim.fn.system(string.format("rm '%s'", snapshot_path))
  vim.fn.system(string.format("rm '%s'", patch_path))
  vim.fn.system(string.format("rm '%s'", marker_path))
end

local function poll_for_changes(bufnr, snapshot_path, patch_path, marker_path, timeout_remaining)
  if vim.fn.filereadable(marker_path) == 1 then
    apply_patch(bufnr, snapshot_path, patch_path, marker_path)
    return
  end

  if timeout_remaining <= 0 then
    vim.notify("Timeout waiting for Opencode response", vim.log.levels.WARN)
    return
  end

  vim.defer_fn(function()
    poll_for_changes(bufnr, snapshot_path, patch_path, marker_path, timeout_remaining - POLL_INTERVAL)
  end, POLL_INTERVAL)
end

-- MAIN FUNCTIONS



local function complete()
  local raw_prompt = table.concat({
    "@this: Implement the missing code in this function or block.",
    "If the function or block is empty, do your best to fill it with the necessary code based on the signature and context.",
    "If it's not empty, look for TODO comments within this function or block, delete it, and follow their instructions.",
    "If it's not empty, and there are no TODO comments, ask for clarification before doing anything.",
    "Feel free to look around the code base and infer more details on what's supposed to be done.",
    "When you have a plan, add your code here, and remove whatever placeholder was there before.",
    "Do NOT touch anything else: all the changes must be localized to the function or block where the comment is.",
    "If you think the task requires more changes in different places, tell me, but do NOT implement them yet.",
  }, "\n")

  local bufnr = vim.api.nvim_get_current_buf()
  local snapshot_path, patch_path, marker_path = generate_diff_paths()
  local prompt = parse_prompt(raw_prompt, patch_path, marker_path)

  copy_buffer(bufnr, snapshot_path)
  copy_buffer(bufnr, patch_path)

  send_prompt(prompt)
  poll_for_changes(bufnr, snapshot_path, patch_path, marker_path, TIMEOUT_MS)
end

local function ask()
  local raw_prompt = vim.fn.input("Ask Opencode! @this: ")
  if raw_prompt == "" then return end

  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(bufnr)
  local prompt = parse_prompt("@this: " .. raw_prompt, path)

  vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)
  send_prompt("@this: " .. prompt)
end

-- SETUP

local M = {}

function M.setup()
  vim.keymap.set("n", "<leader>oa", ask, { desc = "Ask Opencode" })
  vim.keymap.set("n", "<leader>of", complete, { desc = "Complete with Opencode" })
end

return M
