-- lua/plugins/completion.lua
return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter', -- Load when entering insert mode
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',       -- Source for LSP completions
      'hrsh7th/cmp-buffer',       -- Source for buffer words
      'hrsh7th/cmp-path',         -- Source for file system paths
      -- Snippet Engine & Source (Choose one pair)
      -- Option 1: vsnip (your current choice)
      'hrsh7th/vim-vsnip',          -- Snippet engine
      'hrsh7th/cmp-vsnip',          -- cmp source for vsnip

      -- Option 2: LuaSnip (more modern, Lua-based)
      -- 'L3MON4D3/LuaSnip',
      -- 'saadparwaiz1/cmp_luasnip',
      -- Optional: Add snippets
      -- 'rafamadriz/friendly-snippets', -- Requires luasnip
    },
    config = function()
      local cmp = require('cmp')
      local compare = require('cmp.config.compare')
      -- Optional: If using LuaSnip, uncomment the line below
      -- local luasnip = require('luasnip')
      -- Optional: Load snippets if using LuaSnip + friendly-snippets
      -- require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        snippet = {
          -- Choose the expand function for your snippet engine
          -- For vsnip:
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
          -- For LuaSnip:
          -- expand = function(args)
          --   luasnip.lsp_expand(args.body)
          -- end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(), -- Previous item
          ['<C-j>'] = cmp.mapping.select_next_item(), -- Next item
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),      -- Trigger completion
          ['<C-e>'] = cmp.mapping.abort(),           -- Close completion
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection
          -- Additional useful mappings
          ['<Tab>'] = cmp.mapping(function(fallback)
             if cmp.visible() then
               cmp.select_next_item()
             -- Uncomment if using LuaSnip and you want Tab to jump through snippets
             -- elseif luasnip.expand_or_jumpable() then
             --  luasnip.expand_or_jump()
             else
               fallback() -- Fallback to default Tab behavior
             end
          end, { "i", "s" }), -- i: insert mode, s: select mode (for snippets)
          ['<S-Tab>'] = cmp.mapping(function(fallback)
             if cmp.visible() then
               cmp.select_prev_item()
             -- Uncomment if using LuaSnip
             -- elseif luasnip.jumpable(-1) then
             --  luasnip.jump(-1)
             else
               fallback() -- Fallback to default Shift-Tab behavior
             end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          -- Choose the snippet source matching your engine
          { name = 'vsnip' },
          -- { name = 'luasnip' },
          { name = 'path' }, -- Add path source
        }, {
          { name = 'buffer', keyword_length = 5 }, -- Only show buffer words longer than 5 chars
        }),
        -- Optional: Configure appearance (requires a nerd font for icons)
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            -- Define icons for different completion kinds (requires nvim-web-devicons or similar)
            local kind_icons = {
              Text = "",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "",
              Field = "󰇽",
              Variable = "󰂡",
              Class = "󰠱",
              Interface = "",
              Module = "",
              Property = "󰜢",
              Unit = "",
              Value = "󰎠",
              Enum = "",
              Keyword = "󰌋",
              Snippet = "",
              Color = "󰏘",
              File = "󰈙",
              Reference = "",
              Folder = "󰉋",
              EnumMember = "",
              Constant = "󰏿",
              Struct = "",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "󰅲",
            }
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or '?', vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              -- luasnip = "[Snippet]",
              vsnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
         -- Optional: Better sorting
        sorting = {
          comparators = {
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
        -- Optional: Enable border for completion menu
        window = {
           completion = cmp.config.window.bordered(),
           documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
  -- Include the snippet engine chosen above
  { 'hrsh7th/vim-vsnip', event = 'InsertEnter' },
  -- Or if using LuaSnip
  -- { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp', dependencies = { "rafamadriz/friendly-snippets" } },
}
