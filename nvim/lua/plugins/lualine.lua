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

local function short_cwd()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
end

local function git_branch()
  local icon = ""
  return icon .. " " .. vim.fn.FugitiveHead()
end

return {
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

      local tree_extension = {
        sections = { lualine_a = { short_cwd }, },
        inactive_sections = { lualine_b = { short_cwd } },
        filetypes = { "NvimTree" }
      }

      local git_extension = {
        sections = { lualine_a = { git_branch }, lualine_z = { "location" }, },
        inactive_sections = { lualine_b = { git_branch }, lualine_y = { "location" }, },
        filetypes = { "fugitive" }
      }

      require("lualine").setup({
        extensions = { tree_extension, git_extension },
        options = {
          theme = theme,
          icons_enabled = true,
          component_separators = "|",
          section_separators = { left = "", right = "" }
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
          lualine_b = { { "filename", path = 1 } },
          lualine_c = { "diagnostics" },
          lualine_x = { "filetype" },
          lualine_y = { "branch", "diff" },
          lualine_z = { { "location", separator = { right = "" }, left_padding = 2 }, },
        }
      })
    end,
  },
}
