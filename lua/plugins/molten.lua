-- lua/plugins/molten.lua
return {
  "benlubas/molten-nvim",
  version = "^1", -- Use version pinning recommended by the author
  -- We use VimEnter below to defer keymap creation, so lazy=false or ft=... is fine here.
  -- Let's stick with ft for slightly faster startup if not opening python/md immediately.
  ft = { "python", "markdown", "quarto" },
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-tree/nvim-web-devicons" },
  },
  build = ":UpdateRemotePlugins", -- IMPORTANT: Requires UpdateRemotePlugins on first install
  init = function()
    vim.g.molten_auto_open_output = true
    -- vim.g.molten_virt_text_output = true -- Uncomment for virtual text
    -- vim.g.molten_output_win_max_height = 15 -- Adjust output window height
  end,
  config = function()

    -- === Helper Functions ===
    -- Define these first, they don't call Molten commands directly

    -- Helper to run Molten commands safely with delay and checks
    local function run_molten_command(cmd_name, args_str, success_msg, error_msg)
      args_str = args_str or "" -- Ensure args_str is a string
      local full_cmd = cmd_name .. " " .. args_str
      local cmd_exists_name = ":" .. cmd_name -- Format for exists() check

      vim.defer_fn(function()
          if vim.fn.exists(cmd_exists_name) == 2 then -- Check if command exists
            vim.cmd(full_cmd)
            if success_msg then vim.notify(success_msg, vim.log.levels.INFO, { title = "Molten" }) end
          else
            local default_error = "Command '" .. cmd_exists_name .. "' not available. Molten init incomplete or failed?"
            vim.notify(error_msg or default_error, vim.log.levels.ERROR, { title = "Molten" })
          end
      end, 50) -- 50ms delay before checking/executing
    end

    -- Helper specifically for visual mode evaluation which needs the range prefix
    local function run_molten_visual_evaluate()
        local cmd_exists_name = ":MoltenEvaluateVisual"
        vim.defer_fn(function()
            if vim.fn.exists(cmd_exists_name) == 2 then
                -- IMPORTANT: Execute with range prefix. Using feedkeys or nvim_cmd is safer here.
                -- vim.cmd("'<,'>" .. "MoltenEvaluateVisual") -- Sometimes problematic in callbacks
                vim.api.nvim_command("normal! '<,'>:MoltenEvaluateVisual<CR>") -- Use normal mode command execution
                vim.notify("Evaluating selection...", vim.log.levels.INFO, { title = "Molten" })
                 -- Optional: Exit visual mode after sending
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', true)
            else
                vim.notify("Command ':MoltenEvaluateVisual' not available.", vim.log.levels.ERROR, { title = "Molten" })
                 -- Still exit visual mode if the command failed
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', true)
            end
        end, 50) -- 50ms delay
    end


    -- === Define KEYMAPS and WHICHKEY registration inside VimEnter ===
    local group = vim.api.nvim_create_augroup("MoltenPostLoadKeymaps", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group, pattern = "*", desc = "Define Molten keymaps after plugins likely initialized", once = true,
      callback = function()
        local map = vim.keymap.set
        local leader = "<leader>"

        -- Initialization / Kernel Selection (These run Molten commands directly)
        map("n", leader .. "ji", function() run_molten_command("MoltenInit", nil, "Molten Initializing...") end, { desc = "Molten: Initialize/Attach Kernel", noremap = true, silent = true })
        map("n", leader .. "jca", function() run_molten_command("MoltenSelectKernel", nil, "Select Kernel...") end, { desc = "Molten: Select Kernel", noremap = true, silent = true })

        -- Evaluate (Run Molten commands via helper)
        map("n", leader .. "jc", function() run_molten_command("MoltenEvaluateCell", nil, "Evaluating cell...") end, { desc = "Molten: Evaluate Cell", noremap = true, silent = true })
        map("v", leader .. "js", run_molten_visual_evaluate, { desc = "Molten: Evaluate Selection", noremap = true, silent = true }) -- Use dedicated visual helper

        map("n", leader .. "jj", function()
          run_molten_command("MoltenEvaluateCell", nil, "Evaluating cell...") -- Run evaluation first
          run_molten_command("MoltenNextCell") -- Then move to next (no specific success msg needed)
        end, { desc = "Molten: Evaluate Cell & Next", noremap = true, silent = true })

        -- Navigation and Cell Management
        map("n", leader .. "jn", function() run_molten_command("MoltenNextCell") end, { desc = "Molten: Next Cell", noremap = true, silent = true })
        map("n", leader .. "jp", function() run_molten_command("MoltenPrevCell") end, { desc = "Molten: Previous Cell", noremap = true, silent = true })
        map("n", leader .. "jo", function() run_molten_command("MoltenClearOutput") end, { desc = "Molten: Clear Cell Output", noremap = true, silent = true })

        -- Kernel Management
        map("n", leader .. "jk", function() run_molten_command("MoltenInterruptKernel", nil, "Interrupting kernel...") end, { desc = "Molten: Interrupt Kernel", noremap = true, silent = true })
        map("n", leader .. "jr", function() run_molten_command("MoltenRestartKernel", nil, "Restarting kernel...") end, { desc = "Molten: Restart Kernel", noremap = true, silent = true })

        -- WhichKey integration
        local wk_status_ok, wk = pcall(require, "which-key")
        if wk_status_ok then
            wk.register({
              { "", group = "Molten" }, -- Declare the group name for mappings with desc
            })
        end

        -- Optional confirmation
        -- vim.notify("Molten keymaps configured on VimEnter.", vim.log.levels.INFO, { title = "Molten" })

      end, -- End of VimEnter callback
    }) -- End of nvim_create_autocmd for VimEnter

    -- Autocommand for syntax highlighting (Doesn't depend on Molten commands)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      group = vim.api.nvim_create_augroup("MoltenCustomPythonSyntax", { clear = true }),
      callback = function()
        -- Example: Highlight cell separators if needed (Treesitter might handle this)
        vim.cmd("silent! syntax match MoltenCellSeparator /^# %%%%.*$/ containedin=ALLBUT,@Spell")
        vim.cmd("silent! highlight default link MoltenCellSeparator Comment")
      end,
    })

     vim.notify("molten-nvim base config loaded.", vim.log.levels.INFO, { title = "Molten" })

  end, -- End of config function
} -- End of main return table