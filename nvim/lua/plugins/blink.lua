return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  opts = {
    keymap = {
      preset = "none",
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<Tab>"] = { "accept", "fallback" },
    },
    appearance = {
      nerd_font_variant = "normal"
    },
  },
  opts_extend = { "sources.default" }
}
