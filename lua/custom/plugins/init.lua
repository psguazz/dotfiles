-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    {
        "loctvl842/monokai-pro.nvim",
        config = function()
            require("monokai-pro").setup({
                overridePalette = function(filter)
                    return {
                        dark2 = "#19181a",
                        dark1 = "#221f22",
                        background = "#2d2a2e",
                        text = "#fcfcfa",
                        accent1 = "#ff6188",
                        accent2 = "#fc9867",
                        accent3 = "#ffd866",
                        accent4 = "#a9dc76",
                        accent5 = "#78dce8",
                        accent6 = "#ab9df2",
                        dimmed1 = "#c1c0c0",
                        dimmed2 = "#939293",
                        dimmed3 = "#727072",
                        dimmed4 = "#5b595c",
                        dimmed5 = "#403e41",
                    }
                end
            })
            vim.cmd([[colorscheme monokai-pro]])
        end
    },
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        config = function()
            vim.keymap.set("n", "<leader>nt", vim.cmd.Neotree)
            require("neo-tree").setup({
                filesystem = {
                    follow_current_file = { enabled = true },
                    filtered_items = {
                        visible = true,
                        never_show = {
                            ".DS_Store",
                            "thumbs.db"
                        },
                    },
                }
            })
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            require("ibl").setup({
                indent = { char = "│" }
            })
        end
    },
    {
        'numToStr/Comment.nvim',
        lazy = false,
    },
    {
        "kevinhwang91/nvim-hlslens",
        config = function()
            require('hlslens').setup()

            local kopts = { noremap = true, silent = true }

            vim.api.nvim_set_keymap('n', 'n',
                [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'N',
                [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

            vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)
        end
    },
    {
        'AckslD/muren.nvim',
        config = true
    },
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        opts = {},
        config = function()
            require("hardtime").setup()
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
    { "gennaro-tedesco/nvim-peekup" },
    { "nvim-treesitter/nvim-treesitter-context" },
    { "mg979/vim-visual-multi" },
    { "tpope/vim-surround" },
    { "sudormrfbin/cheatsheet.nvim" },
}
