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
            ensure_installed = {
              'typescript-language-server',
              'lua_ls',
              -- Add other Mason-managed servers here
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

      local on_attach = function(client, bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- LSP Keymaps (No changes needed here)
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

        -- Comment out the attach message if desired
        -- print("LSP attached to buffer " .. bufnr .. ": " .. client.name)
      end

      -- Mason-lspconfig setup (No changes needed here)
      mason_lspconfig.setup({})
      mason_lspconfig.setup_handlers({
        function(server_name) -- Default handler for Mason-installed servers
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end,
      })

      -- Explicit setup for MANUALLY installed Pyright (No changes needed here)
      local pyright_path = "/home/febf/Utveckling/Python/venv/venv_py3.12/lsp_pynvim/bin/pyright-langserver"
      local python_executable = "/home/febf/Utveckling/Python/venv/venv_py3.12/lsp_pynvim/bin/python"
      local venv_directory = "/home/febf/Utveckling/Python/venv/venv_py3.12/lsp_pynvim"
      if vim.fn.executable(pyright_path) == 1 then
         lspconfig.pyright.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { pyright_path, "--stdio" },
            settings = {
               python = {
                  analysis = {
                     autoSearchPaths = true,
                     diagnosticMode = "workspace",
                     useLibraryCodeForTypes = true,
                     -- Provide pythonPath and venvPath for clarity, even if auto works
                     pythonPath = python_executable,
                     venvPath = venv_directory,
                  }
               }
            }
         })
      else
          vim.notify("Pyright executable not found at: " .. pyright_path, vim.log.levels.WARN)
      end

      -- Setup for lua_ls with necessary adjustments
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = util.root_pattern("init.lua", ".git"), -- Keep this root detection
        -- *** UPDATED/VERIFIED settings for lua_ls ***
        settings = {
          Lua = {
            -- Tell lua_ls about the Neovim runtime environment
            runtime = {
              version = 'Neovim', -- REQUIRED to understand vim.* APIs
            },
            -- Help lua_ls find files in Neovim's stdpath and your config
            workspace = {
              library = {
                -- Add Neovim's runtime path for standard modules
                vim.fn.expand('$VIMRUNTIME/lua'),
                -- Add your specific configuration path
                vim.fn.stdpath('config') .. '/lua',
              },
              -- Improve performance for large workspaces if needed
              -- maxPreload = 10000,
              -- preloadFileSize = 10000,
              -- Often useful for Neovim configs to avoid checking system libs too much
              checkThirdParty = false,
            },
            -- Define known global variables
            diagnostics = {
              globals = { 'vim', 'require' }, -- Ensure 'vim' is listed, 'require' is common
              -- disable = { "lowercase-global" } -- Optional: disable specific warnings if needed
            },
            -- Other useful settings
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
        -- ****************************************
      })

    end, -- End of main config function
  },
}
