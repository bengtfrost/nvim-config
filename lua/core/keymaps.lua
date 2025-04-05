-- lua/core/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- [[ Navigation ]]
-- Move between windows
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to below window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to above window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move lines up/down
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- [[ Editing ]]
-- Stay in indent mode
map('v', '<', '<gv', { desc = 'Indent line left (visual)'})
map('v', '>', '>gv', { desc = 'Indent line right (visual)'})

-- Paste without losing yanked text
map('v', 'p', '"_dP', { desc = 'Paste without losing yank buffer (visual)'})

-- [[ Buffers / Files / Session ]]
map('n', '<leader>s', '<cmd>w<cr>', vim.tbl_extend('force', opts, { desc = 'Save file' }))
map('n', '<leader>q', '<cmd>q<cr>', vim.tbl_extend('force', opts, { desc = 'Quit window' }))
map('n', '<leader>Q', '<cmd>qa!<cr>', vim.tbl_extend('force', opts, { desc = 'Quit All (Force)' }))
map('n', '<leader>bn', '<cmd>bnext<cr>', vim.tbl_extend('force', opts, { desc = 'Next buffer' }))
map('n', '<leader>bp', '<cmd>bprevious<cr>', vim.tbl_extend('force', opts, { desc = 'Previous buffer' }))
map('n', '<leader>bd', '<cmd>Bdelete<cr>', vim.tbl_extend('force', opts, { desc = 'Delete buffer' })) -- Requires :Bdelete command, often from fzf.vim or similar, or use <cmd>bdelete<cr>

-- [[ Other ]]
-- Clear search highlights
map('n', '<leader><leader>h', '<cmd>nohlsearch<cr>', vim.tbl_extend('force', opts, { desc = 'Clear highlights' }))

-- Terminal (Optional, consider toggleterm.nvim plugin)
-- map('n', '<leader>t', '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })

-- NvimTree Toggle (This will be handled by the plugin config later, but good to have a central place to see it)
-- map('n', '<leader>n', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file tree' })

-- Comment Toggle (Requires comment plugin, will be defined there)
-- map({ 'n', 'v' }, '<leader>gc', -- Action defined in comment plugin config --, { desc = 'Toggle comment' })
