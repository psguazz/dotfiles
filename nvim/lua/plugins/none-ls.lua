return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "jay-babu/mason-null-ls.nvim" },
    },
    config = function()
      none_ls = require("null-ls")
      none_ls.setup({
        sources = {
          none_ls.builtins.formatting.prettierd
        },
      })
    end
  }
}
