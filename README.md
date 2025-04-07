# My Neovim Configuration

[![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)](https://lua.org)
[![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

This repository contains my personal Neovim configuration files, built with Lua and optimized for development workflows on Linux (specifically tested on Fedora with Sway/Foot). It aims for a balance between features, performance, and maintainability using modern Neovim plugins and practices.

## ✨ Features

*   **🚀 Fast Startup:** Utilizes `folke/lazy.nvim` for plugin management and lazy loading.
*   **💻 LSP Integration:** Out-of-the-box support for Lua, Python, TypeScript/JavaScript via `nvim-lspconfig`, `mason.nvim`, and `pyright`.
*   **🤖 Completion:** Smooth completion experience powered by `nvim-cmp` and `LuaSnip`.
*   **🌳 File Explorer:** Integrated file tree using `nvim-tree.lua`.
*   **🔭 Fuzzy Finding:** Powerful fuzzy finding capabilities with `telescope.nvim`.
*   **🎨 Colorscheme:** Uses `EdenEast/nightfox.nvim` (`carbonfox` variant).
*   **💡 Syntax Highlighting:** Enhanced syntax highlighting via `nvim-treesitter`.
*   **⌨️ Keymap Guide:** `folke/which-key.nvim` provides helpful keybinding popups.
*   **🔧 Well-structured:** Modular configuration organized into logical directories (`core`, `plugins`).
*   **⚙️ Sensible Defaults:** Optimized core Neovim settings for a better editing experience.
*   **🐍 Python Ready:** Configured for Neovim's Python provider and `pyright` LSP.

## 📸 Screenshots

*(NvimTree View)*
![NvimTree Example](https://raw.githubusercontent.com/bengtfrost/nvim-config/master/assets/nvim-treeview.png)

*(NvimTree View with Aider AI pair programming in your terminal)*
![NvimTree Example with Aider](https://raw.githubusercontent.com/bengtfrost/nvim-config/master/assets/nvim-treeview_aider-chat.png)

*(Telescope FZF View)*
![Telescope Example](https://raw.githubusercontent.com/bengtfrost/nvim-config/master/assets/nvim-telescope.png)

## 💾 Installation

**Prerequisites:**

*   [Neovim](https://neovim.io/) 0.8+ (preferably 0.9+ or latest stable)
*   [Git](https://git-scm.com/)
*   [Make](https://www.gnu.org/software/make/) (for building `telescope-fzf-native`)
*   A [Nerd Font](https://www.nerdfonts.com/) installed and configured in your terminal (for icons)
*   Python 3 and `pip` (or `uv`) for installing the Neovim provider: `pip install --user pynvim` (or globally)
*   (Optional but Recommended) `ripgrep` (for Telescope live grep), `fd` (for Telescope find files performance).
*   (Optional but Recommended) Node.js/npm (for `pyright`, `typescript-language-server` installation via Mason).

**Steps:**

1.  **Backup your existing Neovim configuration (if any):**
    ```bash
    mv ~/.config/nvim ~/.config/nvim.bak
    # Optional but safer: backup local data/state/cache too
    # mv ~/.local/share/nvim ~/.local/share/nvim.bak
    # mv ~/.local/state/nvim ~/.local/state/nvim.bak
    # mv ~/.cache/nvim ~/.cache/nvim.bak
    ```

2.  **Clone this repository:**
    ```bash
    git clone https://github.com/bengtfrost/nvim-config ~/.config/nvim
    ```

3.  **Start Neovim:**
    ```bash
    nvim
    ```
    *   `lazy.nvim` will automatically bootstrap itself and install all the configured plugins on the first run. This might take a minute or two.
    *   You may be prompted by Mason to install LSPs/tools listed in `ensure_installed`. Confirm if needed. If not prompted, run `:Mason` after startup to verify/install LSPs (`pyright`, `lua_ls`, `typescript-language-server`).

## ⚙️ Configuration Structure

This configuration follows a modular structure:

*   **`init.lua`**: The main entry point. Sets leader key, loads core modules, bootstraps `lazy.nvim`, sets global diagnostics config & autocommands.
*   **`assets/`**: Directory for static assets like images.
*   **`lua/core/`**: Contains base Neovim settings.
    *   `options.lua`: Core editor settings (`vim.opt`).
    *   `keymaps.lua`: Global, non-plugin keybindings (`vim.keymap.set`).
*   **`lua/plugins/`**: Contains configurations for plugins managed by `lazy.nvim`. Each `.lua` file defines one or more related plugins.
    *   `colorscheme.lua`: Theme setup (`nightfox.nvim`).
    *   `comment.lua`: Commenting (`Comment.nvim`).
    *   `completion.lua`: Completion engine (`nvim-cmp`, `LuaSnip`).
    *   `lsp.lua`: Language Server Protocol setup (`nvim-lspconfig`, `mason.nvim`, LSP definitions).
    *   `telescope.lua`: Fuzzy finder (`telescope.nvim`, dependencies).
    *   `treesitter.lua`: Syntax engine (`nvim-treesitter`).
    *   `ui.lua`: File explorer (`nvim-tree.lua`, icons).
    *   `utils.lua`: Utility plugins (`which-key.nvim`, `mini.icons`).

## ⌨️ Keybindings

*   **Leader Key:** `<Space>`
*   Press `<Space>` in Normal Mode and wait briefly to see available mappings via Which-Key.
*   Refer to the [Keymap Summary](KEYMAPS.md) for a detailed list of all mappings.

## 🤝 Contributing

This is a personal configuration, but suggestions or improvements are welcome via issues or pull requests.

## 📜 License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.
