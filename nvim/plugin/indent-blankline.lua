vim.pack.add({
  src = "lukas-reineke/indent-blankline.nvim",
  name = "ibl",
})

require("ibl").setup({
  indent = {
    char = "▏",
  },
})
