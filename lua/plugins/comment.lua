-- lua/plugins/comment.lua
return {
  'numToStr/Comment.nvim',
  -- Pass options directly to setup if using opts = {} isn't needed,
  -- OR keep using opts and merge them in config
  config = function(_, opts) -- Assuming you might still use opts = {} someday
    require('Comment').setup(vim.tbl_deep_extend('force', {
      -- Add plugin options here
      -- For example: disable padding
      -- padding = false,

      -- *** ADD THIS LINE TO DISABLE DEFAULT MAPPINGS ***
      create_default_mappings = false,

    }, opts or {})) -- Merge with any opts defined above

    -- Your custom mappings remain active
    local map = vim.keymap.set
    map({ 'n', 'v' }, '<leader>gc', function()
      require('Comment.api').toggle.linewise.current()
    end, { desc = 'Toggle comment line (custom)' })

    map('v', '<leader>gc', function()
       -- Need '<,'> for visual mode command correctly
       vim.cmd("'<,'>CommentToggle")
    end, { desc = 'Toggle comment selection (custom)' })

     -- You might want a block comment mapping too if you disable defaults
     map({ 'n', 'v' }, '<leader>gb', function()
       require('Comment.api').toggle.blockwise.current()
     end, { desc = 'Toggle comment block (custom)' })
  end,
  -- Optional: If you don't pass any other opts, you can remove the opts table
  -- opts = {},
}
