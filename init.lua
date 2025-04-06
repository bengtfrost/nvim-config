-- ~/.config/nvim/init.lua

-- Set leader key BEFORE loading plugins/keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' -- Optional: Set localleader as well

-- Load core configuration
require('core.options')
require('core.keymaps')

--[[ Python Host Prog commented out ]]

-- [[ Install lazy.nvim package manager ]]
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and load plugins ]]
-- The 'plugins' argument tells lazy to load specs from lua/plugins/
require('lazy').setup('plugins', {
  -- lazy.nvim configuration options
  checker = { enabled = true, notify = false },
  change_detection = { enabled = true, notify = false },

  --[[ *** REMOVE THE TELESCOPE BLOCK FROM HERE ***
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.x',
    dependencies = { ... },
    config = function() ... end,
  },
  ]] -- End of removed block

  -- lazy.nvim will automatically load files matching lua/plugins/*.lua
  -- and lua/plugins/**/*.lua

}) -- End of lazy.setup

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- [[ Diagnostics Configuration ]]
vim.diagnostic.config({
  virtual_text = true, signs = true, underline = true,
  update_in_insert = false, severity_sort = true,
})
vim.opt.signcolumn = 'yes'

-- [[ Auto Commands ]]
-- YankHighlight
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group, pattern = '*',
})
-- NvimTreeClose
local nvimtree_group = vim.api.nvim_create_augroup('NvimTreeClose', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = nvimtree_group,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == 'NvimTree' then
      local tree_bufnr = vim.fn.bufnr('NvimTree')
      if tree_bufnr ~= -1 and vim.api.nvim_get_current_buf() == tree_bufnr then
         vim.defer_fn(function()
             if vim.api.nvim_win_is_valid(1) and #vim.api.nvim_list_wins() == 1 and vim.bo[vim.api.nvim_win_get_buf(1)].filetype == 'NvimTree' then
               vim.cmd.quit()
             end
         end, 10)
      end
    end
  end,
})

-- print("Neovim config loaded!") -- Commented out
