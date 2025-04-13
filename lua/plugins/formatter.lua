-- lua/plugins/formatter.lua
return {
  -- Conform: Formatting engine
  {
    'stevearc/conform.nvim',
    -- Lazily load, but trigger on save or format command
    event = { "BufWritePre" }, -- load before saving
    cmd = { "ConformInfo", "Format" }, -- load on commands
    keys = {
      -- Add keymap for explicit formatting command ([F]ormat [D]ocument)
      {
        "<leader>fd", -- Or <leader>f= or another preferred key
        function()
          require("conform").format({ async = true, lsp_fallback = "always" })
        end,
        mode = { "n", "v" },
        desc = "Format Document/Selection",
      },
    },
    opts = {
      -- Define formatters for specific filetypes
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "black" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" }, -- ** Added JSON **
        yaml = { "prettierd", "prettier" },
        toml = { "taplo" },
        markdown = { "prettierd", "prettier" }, -- ** Added Markdown **
        bash = { "shfmt" },
        -- ["*"] = { "trim_whitespace" }, -- Example: Apply to all files
      },

      -- Configure format on save behavior
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = "always", -- Fallback to LSP if conform formatter fails
      },

      -- Optional: Customize formatter options
      formatters = {
        stylua = {},
        ruff_format = {},
        black = {},
        isort = {}, -- isort often used with black, but ruff_format might handle it
        prettierd = {},
        prettier = {},
        taplo = {},
        shfmt = { args = { "-i", "2" } },
      },
    },
    init = function()
      -- Optional: You can define the :Format command yourself if you want fine-grained control
      -- vim.api.nvim_create_user_command("Format", function(args)
      --   require("conform").format({
      --     async = true,
      --     lsp_fallback = "always",
      --     range = args.range, -- Conform handles visual selections correctly when range=true
      --   })
      -- end, { range = true })
    end,
  },
}
