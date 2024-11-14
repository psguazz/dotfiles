return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

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

    vim.keymap.set("n", "<leader>,", function()
      if harpoon:list()._index <= 1 then
        harpoon:list()._index = harpoon:list()._length + 1
      end

      harpoon:list():prev()
    end)

    vim.keymap.set("n", "<leader>.", function()
      if harpoon:list()._index < 0 or harpoon:list()._index >= harpoon:list()._length then
        harpoon:list()._index = 0
      end
      harpoon:list():next()
    end)

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      callback = function()
        local current_name = vim.fn.bufname()
        local names = harpoon:list():display()
        local index = -1

        for i, name in ipairs(names) do
          local is_current = string.match(current_name, name .. "$")
          if is_current then
            index = i
          end
        end

        harpoon:list()._index = index
      end
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        harpoon:list():add()
      end
    })

    vim.api.nvim_create_user_command("A", function()
      harpoon:list():add()
    end, {})

    vim.api.nvim_create_user_command("Q", function()
      local list = harpoon:list()

      list:remove()
      vim.cmd("bd!")

      local names = vim.tbl_filter(function(n) return n ~= "" end, list:display())

      list:resolve_displayed(names, #names)
      harpoon:sync()
    end, {})

    vim.api.nvim_create_user_command("QA", function()
      harpoon:list():clear()
      vim.cmd("bufdo if bufname() !~ 'NvimTree_1' | bd | endif")
    end, {})
  end
}
