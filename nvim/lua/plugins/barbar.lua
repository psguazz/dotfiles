return {
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    init = function() vim.g.barbar_auto_setup = true end,
    config = function()
      vim.keymap.set("n", "<leader>,", vim.cmd.BufferPrevious, { desc = "Previous buffer" })
      vim.keymap.set("n", "<leader>.", vim.cmd.BufferNext, { desc = "Next buffer" })
    end,
    version = "^1.0.0",
  },
}
