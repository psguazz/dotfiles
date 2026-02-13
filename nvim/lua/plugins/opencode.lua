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

FILL_PROMPT = [[
  @this: Implement the missing code in this function or block.
  If the function or block is empty, do your best to fill it with the necessary code based on the signature and context.
  If it's not empty, look for TODO comments within this function or block and follow their instructions.
  If it's not empty, and there are no TODO comments, ask for clarification before doing anything.
  Feel free to look around the code base and infer more details on what's supposed to be done.
  When you have a plan, add your code here, and remove whatever placeholder was there before.
  Do NOT touch anything else: all the changes must be localized to the function or block where the comment is.
  If you think the task requires more changes in different places, tell me, but do NOT implement them yet.
]]

return {
  "NickvanDyke/opencode.nvim",
  keys = {
    { "<leader>oa", function() ask("@this: ") end,      desc = "Ask opencode about this" },
    { "<leader>of", function() prompt(FILL_PROMPT) end, desc = "Address a TODO comment" },
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
