return {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()

    local mason_registry = require("mason-registry")
    local servers = {
      "elixirls",
      "gopls",
      "lua_ls",
      "pylsp",
      "standardrb",
      "tailwindcss",
      "typescript-language-server",
      "prettier"
    }

    for _, server_name in ipairs(servers) do
      local ok, pkg = pcall(mason_registry.get_package, server_name)
      if ok and not pkg:is_installed() then
        pkg:install()
      end
    end
  end
}
