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
      local palette = require("lib.palette")

      local theme = {
        normal = {
          a = { bg = palette.bg_blue, fg = palette.bg0 },
          b = { bg = palette.bg0, fg = palette.blue },
          c = { bg = palette.bg1, fg = palette.grey },
        },
        insert = {
          a = { bg = palette.bg_green, fg = palette.bg0 },
          b = { bg = palette.bg0, fg = palette.green },
          c = { bg = palette.bg1, fg = palette.grey },
        },
        replace = {
          a = { bg = palette.bg_red, fg = palette.bg0 },
          b = { bg = palette.bg0, fg = palette.red },
          c = { bg = palette.bg1, fg = palette.grey },
        },
        visual = {
          a = { bg = palette.purple, fg = palette.bg0 },
          b = { bg = palette.bg0, fg = palette.purple },
          c = { bg = palette.bg1, fg = palette.grey },
        },
        command = {
          a = { bg = palette.yellow, fg = palette.bg0 },
          b = { bg = palette.bg0, fg = palette.yellow },
          c = { bg = palette.bg1, fg = palette.grey },
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
