return {
  "jbyuki/nabla.nvim",
  config = function()
    vim.keymap.set("n", "<leader>p", function()
      require("nabla").popup()
    end)
  end
}
