local config_dir = vim.fn.stdpath("config") .. "/lua/mods"
local mod_files = vim.fn.globpath(config_dir, "*.lua", false, true)

for _, file in ipairs(mod_files) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  require("mods." .. name).setup()
end
