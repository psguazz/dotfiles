return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    local function on_attach(bufnr)
      require("nvim-tree.api").config.mappings.default_on_attach(bufnr)

      local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

      vim.keymap.set('n', '<C-k>', ":TmuxNavigateUp<CR>", opts)
    end

    require("nvim-tree").setup({
      on_attach = on_attach,
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
}
