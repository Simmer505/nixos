local plugins = {
    'rebelot/kanagawa.nvim',

    'nvim-lualine/lualine.nvim',
    'kyazdani42/nvim-web-devicons',

    'kylechui/nvim-surround',

    'ibhagwan/fzf-lua',

    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',

    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
    },

    {
        'kaarmu/typst.vim',
        ft = 'typst',
        lazy = false,
    },

    'jalvesaq/Nvim-R',

    {
        'RaafatTurki/hex.nvim',
        config = function()
            require('hex').setup()
        end
    },

    'Vigemus/iron.nvim',

    'junegunn/vim-easy-align',

}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(plugins, opts)
