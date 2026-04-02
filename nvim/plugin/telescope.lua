vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "telescope-fzf-native.nvim" then
      local res = vim.system({ "make" }, { cwd = ev.data.path })
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to compile fzf: " .. res, vim.log.levels.ERROR)
      else
        vim.notify("Successfully compiled fzf", vim.log.levels.INFO)
      end
    end
  end,
})

vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim" })
vim.pack.add({ "https://github.com/nvim-telescope/telescope-fzf-native.nvim" })



vim.pack.add({ "https://github.com/nvim-telescope/telescope.nvim" })

local ts = require("telescope.builtin")

vim.keymap.set("n", "<leader><space>", function()
  local ok = pcall(ts.git_files, { use_git_root = false, show_untracked = true })

  if not ok then
    ts.find_files()
  end
end)
vim.keymap.set("n", "<leader>m", function()
  local curent_buffer_folder = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
  ts.find_files({ cwd = curent_buffer_folder })
end)
vim.keymap.set("n", "<leader>fs", function()
  ts.live_grep({ use_regex = true, })
end)
vim.keymap.set("n", "<leader>fS", function()
  ts.live_grep({ use_regex = false, })
end)
vim.keymap.set("n", "<leader>gm", function()
  ts.git_files({ git_command = { "git", "ls-files", "-m" } })
end)

require("telescope").load_extension("fzf")
