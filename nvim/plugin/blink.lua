vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "blink.cmp" then
      local res = vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path })
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to compile blink.cmp: " .. res, vim.log.levels.ERROR)
      else
        vim.notify("Successfully compiled blink.cmp", vim.log.levels.INFO)
      end
    end
  end,
})

vim.pack.add({{
  src = "https://github.com/saghen/blink.cmp",
  version = "v1.10.1",
}})

require("blink.cmp").setup({
  appearance = {
    nerd_font_variant = "normal"
  },
})
