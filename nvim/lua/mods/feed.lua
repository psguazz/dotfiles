local function parse_prompt(prompt)
  local bufnr = vim.api.nvim_get_current_buf()
  local this_path = vim.api.nvim_buf_get_name(bufnr)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local this_ref = string.format("%s:%d:%d", this_path, cursor[1], cursor[2])

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

local function send_prompt(raw_prompt)
  local pane_id = find_opencode_pane()
  if not pane_id then return end

  local prompt = parse_prompt(raw_prompt)

  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)

  send_to_pane(pane_id, prompt)
end

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

  send_prompt(raw_prompt)
end

local function ask()
  local raw_prompt = vim.fn.input("Ask Opencode! @this: ")
  if raw_prompt == "" then return end

  send_prompt(raw_prompt)
end

local M = {}

function M.setup()
  vim.keymap.set("n", "<leader>oa", ask, { desc = "Ask Opencode" })
  vim.keymap.set("n", "<leader>of", complete, { desc = "Complete with Opencode" })
end

return M
