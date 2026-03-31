return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  dependencies = {
    "OXY2DEV/markview.nvim",
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
    },
  },
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local parsers = {
      "bash",
      "c",
      "cpp",
      "css",
      "dockerfile",
      "eex",
      "elixir",
      "embedded_template",
      "gdscript",
      "gdshader",
      "gitcommit",
      "go",
      "godot_resource",
      "graphql",
      "heex",
      "html",
      "javascript",
      "json",
      "latex",
      "lua",
      "po",
      "prolog",
      "python",
      "ruby",
      "rust",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
      "zig",
    }

    for _, parser in ipairs(parsers) do
      ts.install(parser)
    end

    -- Get filetype patterns for autocmd
    local patterns = {}
    for _, parser in ipairs(parsers) do
      local parser_patterns = vim.treesitter.language.get_filetypes(parser)
      for _, pp in pairs(parser_patterns) do
        table.insert(patterns, pp)
      end
    end

    -- Enable treesitter highlighting for installed parsers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = patterns,
      callback = function()
        vim.treesitter.start()
      end,
    })

    -- Setup textobjects
    require("nvim-treesitter-textobjects").setup({
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    })

    -- Optional: Enable treesitter-based folding
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
  end,
}
