local function ask(cmd)
  vim.cmd("silent! write")
  require("opencode").ask(cmd, { submit = true })
  vim.cmd("checktime")
end

return {
  "NickvanDyke/opencode.nvim",
  keys = {
    { "<leader>op", function() ask() end,          desc = "Ask opencode", },
    { "<leader>oa", function() ask("@this: ") end, desc = "Ask opencode about this" },
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
