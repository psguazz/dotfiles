local harpoon = require("harpoon")
local git = require("lib.git")

function _G.harpoon_tabline()
  local names = harpoon:list():display()
  local current_name = vim.fn.bufname()

  local tabline = ""

  for i, name in ipairs(names) do
    local is_current = string.match(current_name, name .. "$")
    local status = git.status(name)
    local tab_name = vim.fn.fnamemodify(name, ":t")

    local group = "Tabline"
    if is_current then group = group .. "Selected" end

    local number_group = group .. "Number"
    local name_group = group .. "Name"
    if status ~= "None" then name_group = name_group .. status end

    local tab = string.format("%%#%s#  %d%%#%s# %s  ", number_group, i, name_group, tab_name)

    tabline = tabline .. tab
  end

  tabline = tabline .. "%#TablineBackground#"

  return tabline
end

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    git.refresh()
  end
})

vim.o.tabline = '%!v:lua.harpoon_tabline()'
