return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
  },
  config = function()
    local ts = require("telescope.builtin")

    vim.keymap.set("n", "<leader><space>", function()
      local ok = pcall(ts.git_files, { use_git_root = false, show_untracked = true })

      if not ok then
        ts.find_files()
      end
    end)
    vim.keymap.set("n", "<leader>m", function()
      ts.git_files({ git_command = { "git", "ls-files", "-m" } })
    end)
    vim.keymap.set("n", "<leader>fs", function()
      ts.live_grep({ use_regex = true, })
    end)
    vim.keymap.set("n", "<leader>fS", function()
      ts.live_grep({ use_regex = false, })
    end)

    require("telescope").load_extension("fzf")
  end
}
