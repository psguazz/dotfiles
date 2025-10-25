local function ask(cmd)
  vim.cmd("silent! write")
  require("opencode").ask(cmd)
  vim.cmd("checktime")
end

return {
  "NickvanDyke/opencode.nvim",
  keys = {
    { "<leader>op", function() ask() end,               desc = "Ask opencode", },
    { "<leader>oa", function() ask("@cursor: ") end,    desc = "Ask opencode about this",      mode = "n", },
    { "<leader>oa", function() ask("@selection: ") end, desc = "Ask opencode about selection", mode = "v", },
  },
}
