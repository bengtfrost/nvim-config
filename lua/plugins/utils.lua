-- lua/plugins/utils.lua (Minimal Working Version)
return {
  {
    'folke/which-key.nvim',
    -- Load eagerly during this stable phase (you can change back to lazy later)
    lazy = false,
    config = function()
      -- Keep debug prints temporarily to confirm loading
      -- print("WhichKey: Attempting minimal setup...")
      local wk_ok, wk = pcall(require, "which-key")
      if not wk_ok then
        -- print("WhichKey: FAILED TO REQUIRE!")
        return
      end

      -- Use an absolutely minimal setup table (empty)
      local setup_ok, err = pcall(wk.setup, {}) -- Pass an empty table
      if not setup_ok then
        -- print("WhichKey: MINIMAL SETUP FAILED! Error: " .. tostring(err))
      else
        -- print("WhichKey: Minimal setup completed successfully.")
      end
    end,
  },

  -- Keep mini.icons listed as it might be needed by other plugins eventually
  {
    'echasnovski/mini.icons',
    lazy = true,
  },
}
