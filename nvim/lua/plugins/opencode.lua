local function ask(cmd)
  vim.cmd("silent! write")
  require("opencode").ask(cmd, { submit = true })
  vim.cmd("checktime")
end

local function prompt(cmd)
  vim.cmd("silent! write")
  require("opencode").prompt(cmd, { submit = true })
  vim.cmd("checktime")
end

TODO_PROMPT = [[
  @this: Read the TODO comment and replace it with the ncessary code.
  Feel free to look around the code base and infer more details on what's supposed to be done.
  When you have a plan, replace the TODO comment with your implementation.
  Do NOT touch anything else: all the changes must be localized to the function or block where the comment is.
  If you think the task requires more changes in different places, tell me, but do NOT implement them yet.
]]

FILL_PROMPT = [[
  @this: Implement the missing code in this empty function or block.
  If the function or block is not empty, ask for clarification before doing anything.
  Feel free to look around the code base and infer more details on what's supposed to be done.
  When you have a plan, add your code here, and remove whatever placeholder was there before.
  Do NOT touch anything else: all the changes must be localized to the function or block where the comment is.
  If you think the task requires more changes in different places, tell me, but do NOT implement them yet.
]]

local function choose_prompt()
  local line = vim.api.nvim_get_current_line()

  if line:match("TODO:") then
    return TODO_PROMPT
  else
    return FILL_PROMPT
  end
end

return {
  "NickvanDyke/opencode.nvim",
  keys = {
    { "<leader>oa", function() ask("@this: ") end,          desc = "Ask opencode about this" },
    { "<leader>of", function() prompt(choose_prompt()) end, desc = "Address a TODO comment" },
  },
  config = function()
    vim.g.opencode_opts = {
      provider = {
        enabled = "tmux",
        tmux = {
          options = "-h -p 30",
        }
      }
    }
  end
}
