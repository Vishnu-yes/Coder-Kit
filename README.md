# Coder-Kit
This is Coder-Kit a small lightweight nvim's powerful coding tool that can too be in your mobile , laptop , non x86_64 , non arm/aarch devices and even in the powerful tool named termux. Hope You use it peacefully and to prove yourself. If you feel that it it broken then ask Chatgpt it will tell you what is going wrong and how can you balance. 

# Why this nvim init ?

This is a powerful nvim coder confug as it even covers arm/arch asm and even x86 asm , however since this config was actually created with my Iqoo z6 Lite 5g which is a arm/aarch based mobile you will face problems only with arm asm however don't worry. 

# What can give error ?

*Deleting too Many things or heavy modifications without the help of Ai or Professionals can make you frustrate and delete nvim*

This is a powerful config but the asm both arm and x86 have non working lsps yeah you Heard right!
Pyright for Python works well but requires that venv to be activated and this block as you project root with this file named "pyrightconfig.jason" , at the core of your Python folder. 

#Python pyright Config ----->
``` Json
{
  "venvPath": "/home/you/Python",
  "venv": "venv",
  "pythonVersion": "3.12",
  "include": ["src", "tests"],
  "reportMissingImports": true,
  "reportMissingTypeStubs": false
}
```
# Java Script , Css and Html Lsps 
Uses tc-lc or something same named lsp hemce you have to work accordingly 
and also if you are going to add any lsp in this config then make sure to add only after the Javascript , Html & Css lsps and before the lua's comment in which I wrote something similar like "--- Lsps end here"

# C & Cpp 
Use as it is Clang and Clangd or clang tidy is much better for c and cpp here is the compilation command for bash and zsh 
```bash/zsh
clang++ filename.cpp -o filename
./filename
```

# x86-64, the X64 works well with qemu-user-x86-64 
Sorry no Lsp for X86-64 as no widely supported chad lsp like clang!
For x86-64 it is better to use nasm as the config is accroding to that
Here is the compilation command for non x86_64 machines 
```bash/zsh
nasm -f elf64 filename.nasm -o filename.o
ld.lld -m elf-x86_64 filename.o -o filename
qemu-user-x86-64 ./filename 
```
*If using x86 device look for chat gpt or some trusted sources for compilation*

# Themes
Theme used is github default white and default black you can even switch to a black or white theme depending on you need by just typing esc + : , and then ---->

```nvim
:lua ToggleGithubTheme()
```
Remeber it is like on off switch with no arguments.

# A lot of things to do take a look & modify accrodingly after reading this!

# History 
1st Edit and Post -- September , 17th , 2025 , Ekadshi , IST ~7:26pm Device Iqoo Z6 Lite 5g!


##### Here is the Ai version of this (Edited on the same day at 8:05pm)

# Neovim Configuration (init.lua)

This repository contains a **Neovim configuration** designed for development in **C, C++, Python, Lua, JavaScript, HTML, CSS, and Assembly (x86/ARM64)**.  
It runs well on **Linux** and **Termux (Android)** with optimized support for **LSP, Treesitter, completion, snippets, linting, themes, and terminal integration**.

---

## 📌 What this configuration does
- Sets up `PATH` to include **Cargo, npm, and Termux binaries** (required for Python/pyright).
- Bootstraps the **lazy.nvim** plugin manager.
- Configures **basic editor settings** (numbers, cursor, colors).
- Provides a **toggleable GitHub theme**.
- Adds **autopairing** of brackets/quotes.
- Enables **autocompletion** with snippets and LSP integration.
- Configures **Language Servers (LSPs)** for C/C++, Python, Lua, JS/TS, HTML, CSS, and Assembly.
- Improves **diagnostics highlighting** for readability.
- Adds **syntax highlighting** and **linting** for Assembly (GAS + NASM).
- Integrates a **terminal inside Neovim** (`toggleterm.nvim`).
- Provides **filetype-specific indentation** and **custom filetype detection**.

---

## ⚡ Why this is essential
- **Productivity**: Auto-completion, snippets, and autopairs reduce repetitive typing.
- **Code intelligence**: LSP provides go-to-definition, hover docs, and code actions.
- **Assembly-ready**: Special support for GAS/NASM/ARM64 assembly (syntax, linting, snippets).
- **Cross-language development**: Works seamlessly for C, C++, Python, JS/TS, Lua, and HTML/CSS.
- **Portability**: Works in Linux and Termux with minimal setup.
- **Customization**: Theme switching and per-language indentation rules.

---

## ⚙️ Configuration Breakdown

### 🔹 PATH Setup
```lua
vim.env.PATH = vim.env.HOME .. "/.cargo/bin:" .. vim.env.PATH
vim.env.PATH = vim.env.HOME .. "/.npm-global/bin:" .. vim.env.PATH
vim.env.PATH = "/data/data/com.termux/files/usr/bin:" .. vim.env.PATH

What it does: Adds Rust’s Cargo, npm global binaries, and Termux’s /usr/bin to PATH.

Why: Required so Neovim can find executables like pyright, clangd, and asm-lsp.



---

🔹 Plugin Manager (lazy.nvim)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

What it does: Installs lazy.nvim if not present.

Why: Manages all plugins cleanly and efficiently.



---

🔹 Basic Settings

vim.o.number = false
vim.o.relativenumber = false
vim.o.cursorline = false
vim.o.termguicolors = true

What it does: Disables line numbers, disables cursorline, and enables true color support.

Why: Keeps UI clean while supporting modern themes.



---

🔹 Theme (GitHub)

require("github-theme").setup({ ... })
vim.cmd("colorscheme github_light_default")

What it does: Loads GitHub theme with a toggle between light and dark.

Why: Provides a familiar and readable coding environment.



---

🔹 Autopairs

require("nvim-autopairs").setup({})

What it does: Automatically closes brackets, quotes, etc.

Why: Saves keystrokes and avoids syntax errors.



---

🔹 Completion (nvim-cmp)

local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true })
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" }
  }),
})

What it does: Enables autocompletion from LSP, snippets, buffer, and filesystem paths.

Why: Improves coding speed and accuracy.



---

🔹 LSP (Language Servers)

local lspconfig = require("lspconfig")

-- Example: Python (Pyright)
lspconfig.pyright.setup({
  cmd = { "/data/data/com.termux/files/usr/bin/pyright-langserver", "--stdio" },
  settings = { python = { pythonPath = "/home/you/Python/venv/bin/python" } }
})

What it does: Configures LSP servers for C/C++ (clangd), Python (pyright), Lua, JS/TS, CSS, HTML, and Assembly.

Why: Provides IDE-like features: code navigation, diagnostics, refactoring, and hover docs.



---

🔹 Diagnostics

vim.diagnostic.config({ virtual_text = true, signs = true })
vim.cmd("highlight DiagnosticError guifg=#fb4934 gui=bold")

What it does: Configures how errors/warnings are displayed.

Why: Makes issues visible without clutter.



---

🔹 Treesitter

require("nvim-treesitter.configs").setup {
  ensure_installed = { "asm", "c", "lua" },
  highlight = { enable = true }
}

What it does: Enables better syntax highlighting.

Why: More accurate than regex-based highlighting.



---

🔹 Assembly Tools

Syntax highlighting: vim-gas

Linting: nvim-lint and ale (with NASM)

Snippets: vim-snippets


Why: Essential for low-level programming workflow.


---

🔹 Terminal Integration

require("toggleterm").setup{
  size = 20,
  open_mapping = [[<c-\>]],
  direction = "horizontal",
}

What it does: Adds a toggleable terminal inside Neovim.

Why: Run compilers, debuggers, or QEMU without leaving the editor.



---

🔹 Filetype Detection & Indentation

vim.filetype.add({
  extension = { s = "gas", asm = "nasm", nasm = "nasm", x86 = "nasm" }
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "python", "lua" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

What it does: Correctly identifies assembly files and enforces 4-space indentation for C/C++/Python/Lua.

Why: Consistency in coding style.



---

🛠️ Installation (Linux)

1. Install Dependencies

# Update system
sudo apt update && sudo apt upgrade -y

# Install Neovim (latest recommended)
sudo apt install neovim git curl -y

# Install language servers
sudo apt install clangd npm python3-pip -y
npm install -g pyright typescript-language-server vscode-langservers-extracted
pip install python-lsp-server

# Assembly tools
sudo apt install nasm binutils -y
# even qemu helps (edited by me)

2. Install Rust (for Cargo tools, optional)

curl https://sh.rustup.rs -sSf | sh

3. Setup Neovim Config

mkdir -p ~/.config/nvim
cd ~/.config/nvim
nano init.lua
# Paste the configuration here

4. Launch Neovim

nvim

Plugins will be automatically installed via lazy.nvim.


---

✅ Now you have a fully working Neovim IDE setup for Linux & Termux!



Do you want me to also include a Termux-specific installation section (with its exact packages and paths), or should we keep the installation steps Linux-only?


