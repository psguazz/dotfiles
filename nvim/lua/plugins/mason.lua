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
      "pyright",
      "ruff",
      "standardrb",
      "tailwindcss-language-server",
      "typescript-language-server",
    }

    mason_registry.refresh(function()
      for _, server_name in ipairs(servers) do
        local ok, pkg = pcall(mason_registry.get_package, server_name)
        if not ok then
          vim.notify("LSP not found: " .. server_name, vim.log.levels.ERROR)
        elseif not pkg:is_installed() then
          pkg:on("install:success", function()
            vim.notify("LSP installed: " .. server_name)
          end)
          pkg:on("install:failed", function()
            vim.notify("Failed to install LSP: " .. server_name, vim.log.levels.ERROR)
          end)
          pkg:install()
        end
      end
    end)
  end
}
