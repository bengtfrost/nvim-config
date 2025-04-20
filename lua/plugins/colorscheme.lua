-- lua/plugins/colorscheme.lua
-- Replace your existing colorscheme file content with this

return {
  "navarasu/onedark.nvim",
  priority = 1000, -- Ensure it loads early
  config = function()
    require("onedark").setup({
      -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
      style = "dark", -- Or 'darker', 'cool', etc.
      transparent = false, -- Show/hide background
      term_colors = true, -- Change terminal color scheme
      ending_tildes = false, -- Show the end-of-buffer tildes
      cmp_itemkind_reverse = false, -- Reverse item kind highlights in cmp menu

      -- Code styles
      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },

      -- Lualine options (if you use lualine)
      lualine = {
        transparent = false, -- lualine center bar transparency
      },

      -- Custom highlights (example)
      -- highlights = {
      --   ["@comment"] = { italic = true },
      --   ["@keyword"] = { bold = true },
      -- },

      -- Plugins setup
      -- You can disable integrations if needed
      diagnostics = {
         darker = true, -- darker colors for diagnostic warnings etc.
         undercurl = true,
         background = true,
      },
    })

    -- Load the colorscheme
    vim.cmd.colorscheme("onedark")

    -- Optional: You can setup highlight groups here if needed
    -- Example: vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  end,
}