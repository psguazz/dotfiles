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
        "nvim-pack/nvim-spectre",
        config = function()
            require('spectre').setup({
                replace_engine = {
                    ["sed"] = {
                        cmd = "sed",
                        args = nil
                    },
                }
            })
            vim.keymap.set("n", "<leader>FS", require("spectre").toggle, { desc = "Toggle Spectre" })
        end
    },
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        opts = {},
        config = function()
            require("hardtime").setup({
                restricted_keys = {
                    ["<Up>"] = { "i", "n", "x" },
                    ["<Down>"] = { "i", "n", "x" },
                    ["<Left>"] = { "i", "n", "x" },
                    ["<Right>"] = { "i", "n", "x" },
                },
                disabled_keys = {
                    ["<Up>"] = {},
                    ["<Down>"] = {},
                    ["<Left>"] = {},
                    ["<Right>"] = {},
                }
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
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        init = function() vim.g.barbar_auto_setup = true end,
        config = function()
            vim.keymap.set("n", "<leader>,", vim.cmd.BufferPrevious, { desc = "Previous buffer" })
            vim.keymap.set("n", "<leader>.", vim.cmd.BufferNext, { desc = "Next buffer" })
        end,
        version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    { "michaeljsmith/vim-indent-object" },
    { "gennaro-tedesco/nvim-peekup" },
    { "nvim-treesitter/nvim-treesitter-context" },
    { "mg979/vim-visual-multi" },
    { "tpope/vim-surround" },
    { "sudormrfbin/cheatsheet.nvim" },
}
