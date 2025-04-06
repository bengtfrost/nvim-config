-- lua/plugins/utils.lua (Refined for Normal Use)
return {
  {
    'folke/which-key.nvim',
    -- Revert to VeryLazy loading
    event = "VeryLazy",
    dependencies = { 'echasnovski/mini.icons' }, -- Add dependency if icons are used
    config = function()
      -- print("WhichKey: Attempting setup...") -- Keep commented
      local wk_ok, wk = pcall(require, "which-key")
      if not wk_ok then
        vim.notify("Failed to load which-key", vim.log.levels.ERROR)
        return
      end

      local setup_ok, err = pcall(wk.setup, {
        plugins = {
          marks = true,
          registers = true,
          spelling = { enabled = true, suggestions = 20 },
        },
        icons = {
          breadcrumb = "»", separator = "➜", group = "+",
        },
        win = {
          border = "rounded",
          -- position = "bottom", -- Commented out as it caused issues
          -- margin = { 1, 0, 1, 0 }, -- Commented out as it caused issues
          padding = { 1, 2, 1, 2 }, -- This seemed okay
          -- winblend = 0, -- Commented out as it caused issues
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 }, -- Fixed typo width = 50 -> width = { min = 20, max = 50 }
          spacing = 3,
          align = "left",
        },
        -- triggers = { "<leader>" }, -- Removed explicit trigger, use default "auto"
      })

      if not setup_ok then
        vim.notify("Failed to setup which-key: " .. tostring(err), vim.log.levels.ERROR)
      else
        -- print("WhichKey: Setup completed.") -- Keep commented
      end
    end,
  },

  {
    'echasnovski/mini.icons',
    lazy = true,
  },
}
