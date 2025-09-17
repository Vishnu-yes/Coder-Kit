# Coder-Kit: Neovim All-in-One Configuration
---
# Note : The readme.md is only the description not the whole init.lua

Coder-Kit is a lightweight but **powerful Neovim configuration** that works on **mobile, laptop, ARM/Arch devices, Termux, and standard Linux desktops**.  
It provides full IDE features for **C, C++, Python, Lua, JavaScript, HTML, CSS, and Assembly (x86/ARM64)** with LSP, completion, snippets, linting, syntax highlighting, themes, and terminal integration.

---

## 📌 What This Configuration Does

- **PATH Setup:** Adds Cargo, npm, and Termux binaries to PATH for LSPs like `pyright` and `clangd`.
- **Plugin Management:** Bootstraps `lazy.nvim` to manage plugins automatically.
- **Basic Editor Settings:** Configures line numbers, cursorline, and enables true color support.
- **Themes:** GitHub light/dark theme with toggle via `:lua ToggleGithubTheme()`.
- **Autopairs:** Automatically closes brackets, quotes, and parentheses.
- **Completion:** `nvim-cmp` with snippets, LSP, buffer, and path completions.
- **LSP Servers:** C/C++ (`clangd`), Python (`pyright`), Lua, JS/TS, HTML, CSS, Assembly (`asm-lsp`).
- **Diagnostics:** Color-coded error/warning highlights.
- **Assembly Tools:** Syntax highlighting (`vim-gas`), linting (`nvim-lint` & `ale`), and snippets (`vim-snippets`).
- **Treesitter:** Accurate syntax highlighting for `asm`, `c`, and `lua`.
- **Terminal Integration:** Toggleable terminal inside Neovim (`toggleterm.nvim`).
- **Filetype Detection & Indentation:** Auto-detects assembly filetypes and enforces 4-space indentation for C/C++/Python/Lua.

---

## ⚡ Why This Configuration Is Essential

- **Productivity:** Snippets, autopairs, and autocompletion reduce repetitive typing.
- **Code Intelligence:** LSP provides go-to-definition, hover docs, references, and refactoring.
- **Assembly Ready:** Full support for GAS/NASM/ARM64 assembly.
- **Cross-Language:** Works seamlessly for C/C++, Python, JS/TS, Lua, HTML/CSS.
- **Portability:** Runs on Linux, ARM devices, and Termux.
- **Customizable:** Easily switch themes and adjust language-specific settings.

---

## ⚙️ Configuration Breakdown

### PATH Setup
```lua
vim.env.PATH = vim.env.HOME .. "/.cargo/bin:" .. vim.env.PATH
vim.env.PATH = vim.env.HOME .. "/.npm-global/bin:" .. vim.env.PATH
vim.env.PATH = "/data/data/com.termux/files/usr/bin:" .. vim.env.PATH

Adds Rust, npm, and Termux binaries to PATH for LSPs and compilers.


Plugin Manager (lazy.nvim)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

Installs lazy.nvim automatically if missing.


Basic Editor Settings

vim.o.number = false
vim.o.relativenumber = false
vim.o.cursorline = false
vim.o.termguicolors = true

Theme (GitHub)

require("github-theme").setup({ options = { transparent = false } })
vim.cmd("colorscheme github_light_default")

Toggle with: :lua ToggleGithubTheme()


Autopairs

require("nvim-autopairs").setup({})

Completion (nvim-cmp)

local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true })
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" }
  }),
})

LSP (Language Servers)

local lspconfig = require("lspconfig")
-- Python
lspconfig.pyright.setup({
  cmd = { "/data/data/com.termux/files/usr/bin/pyright-langserver", "--stdio" },
  settings = { python = { pythonPath = "/home/you/Python/venv/bin/python" } }
})
-- C/C++
lspconfig.clangd.setup({ cmd = { "clangd" }, capabilities = require("cmp_nvim_lsp").default_capabilities() })
-- JS/TS, HTML, CSS, Lua, Assembly: similar setup inside init.lua

Diagnostics

vim.diagnostic.config({ virtual_text = true, signs = true })
vim.cmd("highlight DiagnosticError guifg=#fb4934 gui=bold")
vim.cmd("highlight DiagnosticWarn guifg=#fabd2f gui=bold")
vim.cmd("highlight DiagnosticInfo guifg=#83a598 gui=italic")
vim.cmd("highlight DiagnosticHint guifg=#b8bb26 gui=italic")

Treesitter

require("nvim-treesitter.configs").setup {
  ensure_installed = { "asm", "c", "lua" },
  highlight = { enable = true }
}

Assembly Tools

Syntax: vim-gas

Linting: nvim-lint, ale (with NASM)

Snippets: vim-snippets


Terminal Integration

require("toggleterm").setup{
  size = 20,
  open_mapping = [[<c-\>]],
  direction = "horizontal",
}

Filetype Detection & Indentation

vim.filetype.add({ extension = { s = "gas", asm = "nasm", nasm = "nasm", x86 = "nasm" } })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "python", "lua" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})


---

🛠️ Installation Guide (Step-by-Step)

1. System Update

sudo apt update && sudo apt upgrade -y

2. Install Neovim, Git, Curl

sudo apt install neovim git curl -y

3. Install Language Servers

Python

pip install python-lsp-server pyright

Create venv:


python3 -m venv ~/Python/venv
source ~/Python/venv/bin/activate

JavaScript / TypeScript / HTML / CSS

npm install -g typescript typescript-language-server vscode-langservers-extracted

C / C++

sudo apt install clang clangd clang-tidy -y

Assembly

sudo apt install nasm binutils qemu -y

4. Optional: Rust (Cargo tools)

curl https://sh.rustup.rs -sSf | sh

5. Set Up Neovim Config

mkdir -p ~/.config/nvim
cd ~/.config/nvim
nano init.lua
# Paste the full init.lua configuration here

6. Launch Neovim

nvim

lazy.nvim will automatically install plugins.

Toggle theme: :lua ToggleGithubTheme()



---

💡 Notes

Python Pyright: Make sure venv is activated and a pyrightconfig.json exists at project root:


{
  "venvPath": "/home/you/Python",
  "venv": "venv",
  "pythonVersion": "3.12",
  "include": ["src", "tests"],
  "reportMissingImports": true,
  "reportMissingTypeStubs": false
}

C/C++ Compilation


clang++ filename.cpp -o filename
./filename

NASM Compilation (x86/64)


nasm -f elf64 filename.nasm -o filename.o
ld.lld -m elf-x86_64 filename.o -o filename
qemu-user-x86-64 ./filename

JavaScript / CSS / HTML LSPs: Configured to work with ts_ls, cssls, html LSPs.



---

🍊 This Readme.md credit goes to Chatgpt.
Note : The readme.md is only the description not the whole init.lua
