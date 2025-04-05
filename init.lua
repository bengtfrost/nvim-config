-- ~/.config/nvim/init.lua

-- Set leader key BEFORE loading plugins/keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' -- Optional: Set localleader as well

-- Load core configuration
require('core.options')
require('core.keymaps')

--[[ <<< REMOVE OR COMMENT OUT this line to use system python >>>
-- Tell Neovim which Python to use for the 'neovim' package (pynvim)
vim.g.python3_host_prog = '/home/febf/Utveckling/Python/venv/venv_py3.12/lsp_pynvim/bin/python'
-- By removing/commenting the line above, Neovim will search $PATH for python3
-- Ensure 'pynvim' is installed for the system python3 Neovim finds.
]]

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
})

-- Disable unused providers (Keep this if you want)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- [[ Diagnostics Configuration ]]
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
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
      local tree_bufnr = vim.fn.bufnr('NvimTree')
      if tree_bufnr ~= -1 and vim.api.nvim_get_current_buf() == tree_bufnr then
         vim.defer_fn(function()
             -- Check again before quitting, window state might change fast
             if vim.api.nvim_win_is_valid(1) and #vim.api.nvim_list_wins() == 1 and vim.bo[vim.api.nvim_win_get_buf(1)].filetype == 'NvimTree' then
               vim.cmd.quit()
             end
         end, 10)
      end
    end
  end
})

-- Format on save (Optional - Requires formatters like conform.nvim or LSP formatters configured)
-- local format_group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true })
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   group = format_group,
--   pattern = { '*.py', '*.js', '*.ts', '*.lua' },
--   callback = function(args)
--     vim.lsp.buf.format({ bufnr = args.buf, async = false, timeout_ms = 2000 })
--   end,
-- })

-- print("Neovim config loaded!") -- Commented out
