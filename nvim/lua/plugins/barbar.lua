return {
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    init = function() vim.g.barbar_auto_setup = false end,
    config = function()
      require("barbar").setup({
        animation = false,
      })

      vim.keymap.set("n", "<leader>,", vim.cmd.BufferPrevious, { desc = "Previous buffer" })
      vim.keymap.set("n", "<leader>.", vim.cmd.BufferNext, { desc = "Next buffer" })
    end,
  },
}
