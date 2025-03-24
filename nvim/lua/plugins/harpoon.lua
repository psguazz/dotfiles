local function table_size(t)
  local count = 0

  for _, _ in pairs(t) do
    count = count + 1
  end

  return count
end

local function find_index(list, condition)
  for index, value in ipairs(list) do
    if condition(value) then
      return index
    end
  end

  return nil
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    local pinned = {}

    harpoon:setup()

    local resolve_displayed = function()
      local list = harpoon:list()
      local names = vim.tbl_filter(function(n) return n ~= "" end, list:display())

      list:resolve_displayed(names, #names)
      harpoon:sync()
    end

    local harpoon_sync = function()
      local current_name = vim.fn.fnamemodify(vim.fn.bufname(), ':.')
      local names = harpoon:list():display()
      local index = -1

      for i, name in ipairs(names) do
        if current_name == name then
          index = i
        end
      end

      harpoon:list()._index = index
    end

    local harpoon_add = function()
      local list = harpoon:list()
      local limit = math.max(table_size(pinned) + 5, 9)

      list:add()

      if list:length() > limit then
        local index = find_index(list:display(), function(n) return pinned[n] == nil end)
        list:remove_at(index)
        resolve_displayed()
      end
    end

    local harpoon_remove = function()
      harpoon:list():remove()
      resolve_displayed()

      vim.cmd("bd!")
    end

    local pinned_add = function()
      local current_name = vim.fn.fnamemodify(vim.fn.bufname(), ':.')
      pinned[current_name] = true

      harpoon:list():remove()
      harpoon:list():prepend()
    end

    local pinned_remove = function()
      local current_name = vim.fn.fnamemodify(vim.fn.bufname(), ':.')
      pinned[current_name] = nil

      harpoon_remove()
    end

    local clear_all = function()
      harpoon:list():clear()
      pinned = {}

      vim.cmd("NvimTreeFocus")

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if not buf_name:match("NvimTree_1$") then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end

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

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, { callback = harpoon_sync })
    vim.api.nvim_create_autocmd("BufWritePre", { callback = harpoon_add })

    vim.api.nvim_create_user_command("A", pinned_add, {})
    vim.api.nvim_create_user_command("Q", pinned_remove, {})
    vim.api.nvim_create_user_command("QA", clear_all, {})
  end
}
