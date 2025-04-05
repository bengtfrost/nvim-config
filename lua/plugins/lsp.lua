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
            -- *** List ALL servers to be managed by Mason ***
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

      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Define the on_attach function once to reuse it for all servers
      local on_attach = function(client, bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- LSP Keymaps (Apply to all attached LSPs)
        map('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = '[G]oto [D]eclaration' }))
        map('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = '[G]oto [D]efinition' }))
        map('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover Documentation' }))
        map('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = '[G]oto [I]mplementation' }))
        map('n', '<leader>k', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature Help' }))
        map('n', '<leader>D', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'Type [D]efinition' }))
        map('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = '[R]e[n]ame Symbol' }))
        map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = '[C]ode [A]ction' }))
        map('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = '[G]oto [R]eferences' }))
        map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, vim.tbl_extend('force', opts, { desc = '[F]ormat Document' }))
        map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('force', opts, { desc = '[W]orkspace [A]dd Folder' }))
        map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('force', opts, { desc = '[W]orkspace [R]emove Folder' }))
        map('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, vim.tbl_extend('force', opts, { desc = '[W]orkspace [L]ist Folders' }))
        map('n', '<leader>e', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'Show Line Diagnostics' }))
        map('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Previous Diagnostic' }))
        map('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next Diagnostic' }))
        map('n', '<leader>dq', vim.diagnostic.setloclist, vim.tbl_extend('force', opts, { desc = 'Diagnostics Quickfix List' }))
      end

      -- Configure mason-lspconfig to use the default handler for all servers
      mason_lspconfig.setup({
          -- The list of servers installed by Mason (`ensure_installed` in mason.setup)
          -- will be automatically configured by the handlers below.
      })

      mason_lspconfig.setup_handlers({
        -- Default handler: This will set up pyright, typescript-language-server (tsserver),
        -- using the common capabilities and on_attach function.
        -- It will skip lua_ls because a specific handler exists below.
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            -- NOTE: Pyright, when managed by Mason, should automatically detect
            -- project-specific virtual environments in most standard setups.
            -- Explicit pythonPath/venvPath settings are usually not needed here.
          })
        end,

        -- Keep the explicit setup for lua_ls because it requires specific
        -- settings for the Neovim runtime environment.
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = util.root_pattern("init.lua", ".git"),
            settings = {
              Lua = {
                runtime = { version = 'Neovim' },
                workspace = {
                  library = { vim.fn.expand('$VIMRUNTIME/lua'), vim.fn.stdpath('config') .. '/lua' },
                  checkThirdParty = false,
                },
                diagnostics = { globals = { 'vim', 'require' } },
                telemetry = { enable = false },
                hint = { enable = true },
              },
            },
          })
        end,
      })

      --[[ *** REMOVED THE MANUAL PYRIGHT SETUP BLOCK ***
      -- The setup for pyright is now handled automatically by the
      -- default mason_lspconfig handler above because 'pyright'
      -- is listed in the ensure_installed table for mason.nvim.

      local pyright_path = "..."
      if vim.fn.executable(pyright_path) == 1 then
         lspconfig.pyright.setup({
             -- ... removed ...
         })
      else
          -- ... removed ...
      end
      ]]

    end, -- End of main config function
  },
}
