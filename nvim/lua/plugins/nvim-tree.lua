return {
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          highlight_git = "name",
          icons = {
            glyphs = {
              git = {
                unstaged = "",
                staged = "",
                unmerged = "",
                renamed = "",
                untracked = "",
                deleted = "",
                ignored = "",
              }
            }
          }
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
        update_focused_file = {
          enable = true,
        }
      })

      vim.keymap.set("n", "<leader>nt", vim.cmd.NvimTreeFocus)
    end
  },
}
