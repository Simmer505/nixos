vim.g.mapleader=','
vim.g.maplocalleader=','

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<leader>ff', ':FzfLua files<CR>')
vim.keymap.set('n', '<leader>fb', ':FzfLua buffers<CR>')
vim.keymap.set('n', '<leader>rg', ':FzfLua grep<CR>')

vim.keymap.set('i', '<S-Tab>', '<C-d>')

vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
