-- ~/.config/nvim/init.lua

-- Set leader key BEFORE loading plugins/keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' -- Optional: Set localleader as well

-- Load core configuration
require('core.options')
require('core.keymaps')

-- Tell Neovim which Python to use for the 'neovim' package (pynvim)
vim.g.python3_host_prog = '/home/febf/Utveckling/Python/venv/venv_py3.12/lsp_pynvim/bin/python'

-- [[ Install lazy.nvim package manager ]]
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable', -- Use 'main' for latest features, 'stable' for stability
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and load plugins ]]
require('lazy').setup('plugins', {
  -- lazy.nvim configuration options
  checker = {
    enabled = true, -- Check for plugin updates automatically
    notify = false, -- Don't notify on check, just background check
  },
  change_detection = {
    enabled = true,
    notify = false, -- Automatically reload changes in config files
  },
  -- You can add more lazy configuration options here
  -- performance = { ... }
  -- defaults = { lazy = true } -- Make plugins lazy load by default
})

-- Disable unused providers (Keep this if you want)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- [[ Diagnostics Configuration ]]
-- Moved slightly earlier, applies globally
vim.diagnostic.config({
  virtual_text = true, -- Show diagnostics inline (can be { prefix = '●' } etc.)
  signs = true,
  underline = true,
  update_in_insert = false, -- Don't update diagnostics while typing
  severity_sort = true,
})

-- Set sign column to always be there, prevents jitter
vim.opt.signcolumn = 'yes'

-- [[ Auto Commands ]]

-- Highlight yanked text briefly
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Auto-close NvimTree when it's the last window
local nvimtree_group = vim.api.nvim_create_augroup('NvimTreeClose', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = nvimtree_group,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == 'NvimTree' then
      -- Check if NvimTree is the only window and quit if so
      local tree_bufnr = vim.fn.bufnr('NvimTree')
      if tree_bufnr ~= -1 and vim.api.nvim_get_current_buf() == tree_bufnr then
         -- Delay quit slightly to avoid issues if triggered too fast
         vim.defer_fn(function()
             vim.cmd.quit()
         end, 10)
      end
    end
  end
})

-- Format on save (optional, but often useful)
-- Ensure you have formatters setup via LSP or null-ls/conform.nvim
-- local format_group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true })
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   group = format_group,
--   pattern = { '*.py', '*.js', '*.ts', '*.lua' }, -- Add file types you want formatted
--   callback = function(args)
--     vim.lsp.buf.format({ bufnr = args.buf, async = false, timeout_ms = 2000 }) -- Use async=false for write pre
--   end,
-- })

-- print("Neovim config loaded!") -- Confirmation message
