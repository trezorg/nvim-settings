return {
    { 'tpope/vim-sleuth',    event = 'VeryLazy' },
    { 'tpope/vim-repeat',    event = 'VeryLazy' },
    { 'tpope/vim-rhubarb' },
    { 'tpope/vim-commentary' },
    { 'tpope/vim-unimpaired' },
    { 'tpope/vim-surround' },
    { 'tpope/vim-repeat' },
    { 'tpope/vim-abolish',   event = 'VeryLazy' },
    { 'mitsuhiko/vim-jinja', event = 'VeryLazy' },
    {
        "https://github.com/dstein64/nvim-scrollview",
        event = 'VeryLazy',
        lazy = false,
        config = true,
        opts = {
            excluded_filetypes = { 'nerdtree' },
            current_only = true,
            base = 'left',
            column = 1,
            signs_on_startup = { 'all' },
            diagnostics_severities = { vim.diagnostic.severity.WARN }
        }
    },
    {
        "iamcco/markdown-preview.nvim",
        event = 'VeryLazy',
        lazy = false,
        config = function()
            vim.fn["mkdp#util#install"]()
            vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', { silent = true, desc = 'MarkdownPreview' })
            vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<CR>',
                { silent = true, desc = 'MarkdownPreviewStop' })
        end,
    },
    {
        'echasnovski/mini.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        version = false,
        event = 'VeryLazy',
        config = function(_, _) -- opts
            require('mini.files').setup()
            vim.keymap.set('n', '<leader>fm', '<cmd>:lua MiniFiles.open()<CR>', { silent = true, desc = 'Open Minifile' })
            vim.keymap.set('n', '<leader>ftm', '<cmd>tabnew | :lua MiniFiles.open()<CR>',
                { silent = true, desc = 'Open Minifile new tab' })
            -- set termguicolors to enable highlight groups
            vim.opt.termguicolors = true
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function() -- opts
            require('nvim-tree').setup({
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
                }
            })
            vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { silent = true, desc = 'NeoVim Tree' })
        end,
    },
    {
        'crispgm/nvim-tabline',
        event = 'VeryLazy',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = true,
        opts = {
            show_index = true,           -- show tab index
            show_modify = true,          -- show buffer modification indicator
            show_icon = true,            -- show file extension icon
            fnamemodify = ':p:.',        -- file name modifier
            modify_indicator = '[+]',    -- modify indicator
            no_name = 'No name',         -- no name buffer name
            brackets = { '[', ']' },     -- file name brackets surrounding
            inactive_tab_max_length = 0, -- max length of inactive tab titles, 0 to ignore
        },
    },
    { 'nvim-lua/plenary.nvim' },
    {
        'tpope/vim-fugitive',
        cmd = { 'Git', 'GBrowse', 'Gdiffsplit', 'Gvdiffsplit' },
        dependencies = {
            'tpope/vim-rhubarb',
        },
        -- stylua: ignore
        keys = {
            { "<leader>gs",  "<cmd>Git<cr>",               desc = "Status" },
            { "<leader>gb",  "<cmd>Git blame<cr>",         desc = "Blame" },
            { "<leader>gl",  "<cmd>Git log<cr>",           desc = "Log" },
            { "<leader>gdd", "<cmd>Git diff<cr>",          desc = "Diff" },
            { "<leader>gdc", "<cmd>Git diff --cached<cr>", desc = "Diff cached" },
        },
    },
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        opts = { options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help' } },
        -- stylua: ignore
        keys = {
            { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            {
                "<leader>qd",
                function() require("persistence").stop() end,
                desc =
                "Don't Save Current Session"
            },
        },
    },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = {
            defaults = {
                ['<leader>g'] = { name = '+Git' },
            },
        },
    },
    {
        'Pocco81/auto-save.nvim',
        event = 'VeryLazy',
        opts = {
            enabled = true,
            execution_message = {
                message = function() -- message to print on save
                    return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
                end,
                dim = 0.18,               -- dim the color of `message`
                cleaning_interval = 1000, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
            },
            -- trigger_events = { "InsertLeave", "TextChanged" },
            trigger_events = { "InsertLeave" },
            condition = function(buf)
                local fn = vim.fn
                local utils = require("auto-save.utils.data")

                if
                    fn.getbufvar(buf, "&modifiable") == 1 and
                    utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
                    return true -- met condition(s), can save
                end
                return false    -- can't save
            end,
            debounce_delay = 1000,
        },
    },
}
