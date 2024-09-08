local sonokai_palette = {
  bg0 = "#2c2e34",
  bg1 = "#33353f",
  bg2 = "#363944",
  bg3 = "#3b3e48",
  bg4 = "#414550",
  bg_blue = "#85d3f2",
  bg_dim = "#222327",
  bg_green = "#a7df78",
  bg_red = "#ff6077",
  black = "#181819",
  blue = "#76cce0",
  diff_blue = "#354157",
  diff_green = "#394634",
  diff_red = "#55393d",
  diff_yellow = "#4e432f",
  fg = "#e2e2e3",
  green = "#9ed072",
  grey = "#7f8490",
  grey_dim = "#595f6f",
  none = "NONE",
  orange = "#f39660",
  purple = "#b39df3",
  red = "#fc5d7c",
  yellow = "#e7c664",
}

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

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local theme = {
        normal = {
          a = { bg = sonokai_palette.bg_blue, fg = sonokai_palette.bg0 },
          b = { bg = sonokai_palette.bg0, fg = sonokai_palette.blue },
          c = { bg = sonokai_palette.bg1, fg = sonokai_palette.grey },
        },
        insert = {
          a = { bg = sonokai_palette.bg_green, fg = sonokai_palette.bg0 },
          b = { bg = sonokai_palette.bg0, fg = sonokai_palette.green },
          c = { bg = sonokai_palette.bg1, fg = sonokai_palette.grey },
        },
        replace = {
          a = { bg = sonokai_palette.bg_red, fg = sonokai_palette.bg0 },
          b = { bg = sonokai_palette.bg0, fg = sonokai_palette.red },
          c = { bg = sonokai_palette.bg1, fg = sonokai_palette.grey },
        },
        visual = {
          a = { bg = sonokai_palette.purple, fg = sonokai_palette.bg0 },
          b = { bg = sonokai_palette.bg0, fg = sonokai_palette.purple },
          c = { bg = sonokai_palette.bg1, fg = sonokai_palette.grey },
        },
        command = {
          a = { bg = sonokai_palette.yellow, fg = sonokai_palette.bg0 },
          b = { bg = sonokai_palette.bg0, fg = sonokai_palette.yellow },
          c = { bg = sonokai_palette.bg1, fg = sonokai_palette.grey },
        },
      }

      require("lualine").setup({
        extensions = { "nvim-tree" },
        options = {
          theme = theme,
          icons_enabled = true,
          component_separators = "|",
          section_separators = { left = "", right = "" }
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { { "location", separator = { right = "" }, left_padding = 2 }, },
        }
      })
    end,
  },

  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    init = function() vim.g.barbar_auto_setup = true end,
    config = function()
      vim.keymap.set("n", "<leader>,", vim.cmd.BufferPrevious, { desc = "Previous buffer" })
      vim.keymap.set("n", "<leader>.", vim.cmd.BufferNext, { desc = "Next buffer" })
    end,
    version = "^1.0.0",
  },
}
