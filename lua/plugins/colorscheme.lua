-- lua/plugins/colorscheme.lua
-- Using onedarkpro.nvim

return {
  "olimorris/onedarkpro.nvim",
  priority = 1000, -- Load early
  -- lazy = false, -- Uncomment this if the init approach below still fails
  init = function()
    -- Set the colorscheme immediately after the plugin is loaded
    -- Trying the base name "onedark" as suggested by some Vim conventions
    -- and the original theme name.
    vim.cmd.colorscheme("onedark")
  end,
  config = function()
    -- The main configuration for the plugin can still run here.
    -- This call might influence how the "onedark" theme (set in init) looks.
    require("onedarkpro").setup({
      -- Add any specific onedarkpro options here if desired
      -- e.g., styles = { comments = "italic" }
    })
    -- NOTE: We removed the vim.cmd.colorscheme call from here.
  end,
}