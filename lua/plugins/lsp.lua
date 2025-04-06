-- lua/plugins/lsp.lua
return {
  -- LSP Base & Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Mason manages installations
      {
        'williamboman/mason.nvim',
        config = function()
          require('mason').setup({
            -- List ALL servers to be managed by Mason
            ensure_installed = {
              'typescript-language-server', -- For TypeScript/JavaScript
              'lua_ls',                   -- For Lua
              'pyright',                  -- For Python (will be installed/managed by Mason)
              -- Add any other LSPs, formatters, linters you want Mason to manage
            },
          })
        end,
      },
      -- Bridge between Mason and lspconfig
      'williamboman/mason-lspconfig.nvim',
      -- Completion integration
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local util = require('lspconfig.util') -- Needed for root_pattern
      local mason_lspconfig = require('mason-lspconfig')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')

      -- Get default LSP capabilities provided by cmp_nvim_lsp
      -- This enhances the LSP client's abilities, especially for completion
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Define the on_attach function once to reuse it for all servers
      -- This function runs whenever an LSP server successfully attaches to a buffer
      local on_attach = function(client, bufnr)
        -- client: LSP client object
        -- bufnr: Buffer number the client attached to

        -- Helper function for setting keymaps specific to this buffer
        local map = vim.keymap.set
        -- Default options for LSP keymaps: non-recursive, silent
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- LSP Keymaps (Apply to all attached LSPs)
        -- See :help vim.lsp.buf and :help vim.diagnostic
        map('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = '[G]oto [D]eclaration' }))
        map('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = '[G]oto [D]efinition' }))
        map('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover Documentation' }))
        map('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = '[G]oto [I]mplementation' }))
        map('n', '<leader>k', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature Help' }))
        map('n', '<leader>D', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'Type [D]efinition' }))
        map('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = '[R]e[n]ame Symbol' }))
        map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = '[C]ode [A]ction' }))
        map('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = '[G]oto [R]eferences' }))

        -- *** CHANGED MAPPING FOR LSP FORMAT ***
        -- map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, vim.tbl_extend('force', opts, { desc = '[F]ormat Document' })) -- OLD MAPPING
        map('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, vim.tbl_extend('force', opts, { desc = '[L]SP [F]ormat' })) -- NEW MAPPING
        -- *************************************

        map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('force', opts, { desc = '[W]orkspace [A]dd Folder' }))
        map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('force', opts, { desc = '[W]orkspace [R]emove Folder' }))
        map('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, vim.tbl_extend('force', opts, { desc = '[W]orkspace [L]ist Folders' }))
        map('n', '<leader>e', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'Show Line Diagnostics' }))
        map('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Previous Diagnostic' }))
        map('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next Diagnostic' }))
        map('n', '<leader>dq', vim.diagnostic.setloclist, vim.tbl_extend('force', opts, { desc = 'Diagnostics Quickfix List' }))

        -- Optional: You could add highlighting for the symbol under the cursor on CursorHold
        -- if client.server_capabilities.documentHighlightProvider then
        --   local high_group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
        --   vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
        --     buffer = bufnr,
        --     group = high_group,
        --     callback = vim.lsp.buf.document_highlight
        --   })
        --   vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
        --     buffer = bufnr,
        --     group = high_group,
        --     callback = vim.lsp.buf.clear_references
        --   })
        -- end

      end -- End of on_attach function

      -- Configure mason-lspconfig to handle connections
      mason_lspconfig.setup({
          -- Settings for mason-lspconfig itself, if needed (usually not)
          -- The list of servers to automatically configure is derived from
          -- what's installed via Mason and handled by setup_handlers below.
      })

      -- Setup handlers tell mason-lspconfig HOW to configure each server
      mason_lspconfig.setup_handlers({
        -- Default handler: This function runs for any server installed via Mason
        -- that doesn't have a more specific handler defined below.
        -- It will configure pyright and typescript-language-server (tsserver).
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities, -- Pass capabilities from nvim-cmp
            on_attach = on_attach,       -- Use the common on_attach function for keymaps
            -- General server settings can go here if needed,
            -- but often server-specific settings are better handled
            -- in dedicated handlers or config files (like pyrightconfig.json).
          })
        end,

        -- Specific handler for lua_ls:
        -- We keep this separate because lua_ls needs special settings
        -- to understand the Neovim environment correctly.
        -- This handler overrides the default handler *only* for lua_ls.
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            -- Helps lua_ls find the root of your Neovim config project
            root_dir = util.root_pattern("init.lua", ".git"),
            settings = {
              Lua = {
                -- Crucial: Tells lua_ls about Neovim's specific Lua API (vim.*)
                runtime = { version = 'Neovim' },
                -- Configure workspace settings
                workspace = {
                  -- Add standard Neovim runtime library path
                  library = {
                    vim.fn.expand('$VIMRUNTIME/lua'),
                    -- Add your own configuration's Lua path
                    vim.fn.stdpath('config') .. '/lua',
                  },
                  -- Can prevent noisy diagnostics from libraries you don't control
                  checkThirdParty = false,
                },
                -- Define known global variables to avoid warnings
                diagnostics = {
                  globals = { 'vim', 'require' },
                },
                -- Disable telemetry
                telemetry = { enable = false },
                -- Enable hints (can be helpful)
                hint = { enable = true },
              },
            },
          })
        end, -- End of lua_ls specific handler

      }) -- End of mason_lspconfig.setup_handlers

      -- The manual pyright setup block has been removed as pyright
      -- is now handled by Mason and the default handler above.

    end, -- End of the main config function for nvim-lspconfig
  }, -- End of the nvim-lspconfig plugin specification
} -- End of the return table for the file
