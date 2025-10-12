vim.api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', {})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(args)
    local opts = { buffer = args.buf }

    vim.keymap.set("n", "<leader>R", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>go", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  end
})

vim.lsp.enable({
  "elixir-ls",
  "gopls",
  "lua-language-server",
  "pyright",
  "ruff",
  "standardrb",
  "tailwindcss-language-server",
  "typescript-language-server",
})
