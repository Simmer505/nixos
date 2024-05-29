require('config/keymaps')
require('config/settings')
require('config/plugins')
require('config/plugins/lualine')
require('config/plugins/lspconfig')

local vimscriptpath = vim.fn.stdpath("config") .. "/lua/config/vimscript/"

vim.cmd('source' .. vimscriptpath .. 'init.vim')
