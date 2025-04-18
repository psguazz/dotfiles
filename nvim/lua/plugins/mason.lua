return {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()

    local mason_registry = require("mason-registry")
    local servers = {
      "elixir-ls",
      "erb-formatter",
      "gopls",
      "lua-language-server",
      "prettier",
      "python-lsp-server",
      "standardrb",
      "tailwindcss-language-server",
      "typescript-language-server",
    }

    for _, server_name in ipairs(servers) do
      local ok, pkg = pcall(mason_registry.get_package, server_name)
      if not ok then
        vim.notify("LSP not found: " .. server_name, vim.log.levels.ERROR)
      elseif not pkg:is_installed() then
        pkg:install()
      end
    end
  end
}
