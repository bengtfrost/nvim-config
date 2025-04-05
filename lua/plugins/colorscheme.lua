-- lua/plugins/colorscheme.lua
return {
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('nightfox').setup({
        options = {
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,

          -- Customize general appearance
          styles = {
            comments = "italic",
            constants = "bold",
            keywords = "italic",
            -- functions = "none", -- REMOVE THIS LINE
            -- variables = "none", -- REMOVE THIS LINE
            types = "italic",
          },

          inverse = {
            visual = false,
            search = false,
          },
          modules = {}
        },
        palettes = {},
        groups = {}
      })

      -- Load the carbonfox variant
      vim.cmd.colorscheme 'carbonfox'

    end,
  },
}
