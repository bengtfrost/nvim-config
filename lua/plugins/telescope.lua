-- lua/plugins/telescope.lua
return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.x', -- Or latest stable tag like 'stable' or omit for latest commit
    lazy = true, -- Keep it lazy loaded
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Optional: FZF native sorter for performance
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
    },
    -- Define keys here so lazy.nvim knows about them and can trigger loading
    keys = {
      -- Mode 'n' for normal mode
      { '<leader>ff', '<cmd>Telescope find_files<cr>',  desc = '[F]ind [F]iles' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>',   desc = '[F]ind by [G]rep' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>',     desc = '[F]ind [B]uffers' },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>',   desc = '[F]ind [H]elp' },
      { '<leader>fo', '<cmd>Telescope oldfiles<cr>',    desc = '[F]ind [O]ld Files' },
      { '<leader>fr', '<cmd>Telescope resume<cr>',      desc = '[F]ind [R]esume' },
      { '<leader>fd', '<cmd>Telescope diagnostics<cr>', desc = '[F]ind [D]iagnostics' },
      -- You can add more Telescope mappings here following the pattern
      -- { '<leader>f<something>', '<cmd>Telescope <command_name><cr>', desc = 'Description' },
    },
    -- config function now only contains setup and loading extensions
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          -- file_ignore_patterns = { "node_modules", ".git" },
          -- other defaults...
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          -- configure other extensions if you use them
        },
      })

      -- Load fzf extension if installed & configured
      pcall(telescope.load_extension, 'fzf')
      -- Load other extensions here if needed
    end,
  },
}
