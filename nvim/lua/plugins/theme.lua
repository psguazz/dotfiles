return {
  { "sainnhe/sonokai", },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup({
        indent = {
          char = "▏",
        },
      })
    end
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup()
      vim.notify = require("notify")
    end
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  },

  {
    "goolord/alpha-nvim",
    config = function()
      require "alpha".setup(require "alpha.themes.startify".config)
    end
  },
}
