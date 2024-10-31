return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      local palette = require("lib.palette")
      local git = require("lib.git")

      harpoon:setup()

      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
      vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end)
      vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end)
      vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end)
      vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end)
      vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end)

      vim.keymap.set("n", "<leader>,", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<leader>.", function() harpoon:list():next() end)

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          harpoon:list():add()
        end
      })

      vim.api.nvim_create_user_command("A", function() harpoon:list():add() end, {})
      vim.api.nvim_create_user_command("Q", function() harpoon:list():remove() end, {})
      vim.api.nvim_create_user_command("QA", function() harpoon:list():clear() end, {})

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

      function refresh()
        git.refresh()
        vim.fn.timer_start(2000, function() refresh() end)
      end

      refresh()
      vim.o.tabline = '%!v:lua.harpoon_tabline()'
    end
  }
}
