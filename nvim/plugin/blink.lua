vim.pack.add({
  src = "saghen/blink.cmp",
  version = "1.*",
})

require("blink.cmp").setup({
  appearance = {
    nerd_font_variant = "normal"
  },
})
