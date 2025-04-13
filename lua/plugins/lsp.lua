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
            -- List ALL servers AND FORMATTERS to be managed by Mason
            ensure_installed = {
              -- LSPs:
              'typescript-language-server',
              'lua_ls',
              'pyright',
              -- Formatters:
              'stylua',       -- For Lua
              'black',        -- For Python (popular choice)
              'isort',        -- For Python import sorting
              'ruff',         -- For Python (can format and lint - using ruff_format)
              'prettierd',    -- For JS/TS/JSON/YAML/MD (daemonized version)
              'prettier',     -- Fallback for prettierd / TOML?
              'taplo',        -- For TOML
              -- Linters (optional - for future use with lint.nvim maybe):
              -- 'eslint_d',
              -- 'flake8',
            },
            -- Optional: Auto-install servers/tools in ensure_installed
            -- automatic_installation = true,
          })
        end,
      },
      -- Bridge between Mason and lspconfig
      'williamboman/mason-lspconfig.nvim',
      -- Completion integration
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      -- Add Conform as a dependency for LSP fallback awareness (optional but good)
      'stevearc/conform.nvim',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local util = require('lspconfig.util')
      local mason_lspconfig = require('mason-lspconfig')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')

      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Define the on_attach function once to reuse it for all servers
      local on_attach = function(client, bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- *** Important: Disable LSP formatting requests if using conform ***
        -- This prevents LSP and conform fighting over formatting the buffer.
        -- We'll map our format keybind to conform instead.
        if client.supports_method("textDocument/formatting") then
           opts.desc = "LSP Formatting (Disabled, use Conform)"
           map({'n', 'v'}, "<leader>lf", "<cmd>echo 'Use Conform for formatting'<CR>", opts)
        else
           -- If LSP doesn't support formatting, the keybind can do nothing or something else
           -- Or just don't define it for clients without formatting support
        end
        -- The old mapping is removed below in the list

        -- Other LSP Keymaps (No changes needed here)
        map('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = '[G]oto [D]eclaration' }))
        map('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = '[G]oto [D]efinition' }))
        map('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover Documentation' }))
        map('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = '[G]oto [I]mplementation' }))
        map('n', '<leader>k', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature Help' }))
        map('n', '<leader>D', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'Type [D]efinition' }))
        map('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = '[R]e[n]ame Symbol' }))
        map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = '[C]ode [A]ction' }))
        map('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = '[G]oto [R]eferences' }))
        -- map('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, vim.tbl_extend('force', opts, { desc = '[L]SP [F]ormat' })) -- REMOVED/REPLACED ABOVE
        map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('force', opts, { desc = '[W]orkspace [A]dd Folder' }))
        map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('force', opts, { desc = '[W]orkspace [R]emove Folder' }))
        map('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, vim.tbl_extend('force', opts, { desc = '[W]orkspace [L]ist Folders' }))
        map('n', '<leader>e', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'Show Line Diagnostics' }))
        map('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Previous Diagnostic' }))
        map('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next Diagnostic' }))
        map('n', '<leader>dq', vim.diagnostic.setloclist, vim.tbl_extend('force', opts, { desc = 'Diagnostics Quickfix List' }))
      end

      -- Configure mason-lspconfig
      mason_lspconfig.setup({})
      mason_lspconfig.setup_handlers({
        -- Default handler
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach, -- Use the modified on_attach
          })
        end,
        -- Specific handler for lua_ls
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach, -- Use the modified on_attach
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
      }) -- End mason_lspconfig.setup_handlers

    end, -- End of nvim-lspconfig config function
  }, -- End of nvim-lspconfig plugin spec
} -- End return
