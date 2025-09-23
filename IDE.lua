-- Enhanced Neovim init.lua (nvim 0.11.4)
-- Opinionated "IDE" style config that:
--  - Avoids mason (manual LSP/treesitter install friendly for arm64)
--  - Provides easy tables to customize LSP servers and treesitter installs
--  - Better gutter icons, diagnostics, and UI polish
--  - Adds LunarVim default theme plus a collection of top-notch themes
--  - Uses lazy.nvim as plugin manager
--  - Suitable starting point — edit the `M` tables below to customize

------------------------------------------------------------
-- Quick notes for arm64 users (no mason):
-- Install language servers yourself with your package manager or via npm/pip/cargo.
-- Example installs:
--   - pyright via `npm i -g pyright` or use pyright-langserver from pipx
--   - clangd via your distro package or clang-tools
--   - typescript's tsserver via `npm i -g typescript typescript-language-server`
--   - lua-language-server: use the prebuilt for your arch or build from source
-- Set the command paths below in `M.lsp.servers` if server is not in your PATH.
------------------------------------------------------------

local M = {}

-- =====================
-- 1) Leader keys
-- =====================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =====================
-- 2) Environment PATH additions (termux example kept)
-- =====================
vim.env.PATH = table.concat({
  "/data/data/com.termux/files/usr/bin",
  vim.env.HOME .. "/.cargo/bin",
  vim.env.HOME .. "/.npm-global/bin",
  vim.env.PATH,
}, ":")

-- =====================
-- 3) Bootstrap lazy.nvim
-- =====================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =====================
-- 4) Basic editor settings
-- =====================
local o = vim.o
o.number = true
o.relativenumber = true
o.cursorline = true
o.termguicolors = true
o.signcolumn = "yes"
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.clipboard = "unnamedplus"
vim.cmd("filetype plugin indent on")

-- =====================
-- 5) Plugins (lazy.nvim)
-- =====================
require("lazy").setup({
  -- core
  { "nvim-lua/plenary.nvim",               lazy = true },
  { "nvim-tree/nvim-web-devicons",         lazy = true },

  -- themes (lots of great defaults)
  { "ellisonleao/gruvbox.nvim",            priority = 1000 },
  { "projekt0n/github-nvim-theme",         name = "github-theme",                           priority = 999 },
  { "lunarvim/colorschemes" }, -- LunarVim’s default colorscheme collection
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim",                     name = "catppuccin" },
  { "EdenEast/nightfox.nvim" },
  { "shaunsingh/nord.nvim" },
  { "Mofiqul/vscode.nvim" },
  { "navarasu/onedark.nvim" },
  { "rebelot/kanagawa.nvim" },

  -- UI
  { "lewis6991/gitsigns.nvim",             event = { "BufReadPre", "BufNewFile" } },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl",                                    event = { "BufReadPost", "BufNewFile" } },
  { "akinsho/bufferline.nvim",             version = "*",                                   dependencies = "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
  { "nvim-tree/nvim-tree.lua",             dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- autopairs
  { "windwp/nvim-autopairs",       event = "InsertEnter" },

  -- Your Plugins here
  -- ====Formattor
  { "stevearc/conform.nvim",       event = "BufWritePre" },

  --=====Statusline l
  { "nvim-lualine/lualine.nvim",   dependencies = { "nvim-tree/nvim-web-devicons" } },

  --===== Dap  UI
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui",        dependencies = { "mfussenegger/nvim-dap" } },
  { "williamboman/mason.nvim",     enabled = false }, -- keep off since you don’t use mason
  { "nvim-neotest/nvim-nio" },                        ---dependencies
  --==== Sessions & workspace
  { "rmagatti/auto-session" },
  { "natecraddock/workspaces.nvim" },

  -- Your custom plugins end here

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn
          .executable('make') == 1
    end
  },
  { "nvim-telescope/telescope-file-browser.nvim" },

  -- treesitter
  { "nvim-treesitter/nvim-treesitter",           build = ":TSUpdate" },

  -- LSP config
  { "neovim/nvim-lspconfig",                     event = { "BufReadPre", "BufNewFile" }, dependencies = { "hrsh7th/cmp-nvim-lsp" } },

  -- snippets
  { "L3MON4D3/LuaSnip",                          lazy = true },
  { "honza/vim-snippets",                        lazy = true },

  -- terminal
  { "akinsho/toggleterm.nvim",                   version = "*" },
})

-- =====================
-- 6) UI tweaks: colorscheme, diagnostics signs, gutter icons
-- =====================
vim.o.background = "dark"
pcall(vim.cmd, "colorscheme lunar") -- default theme

-- diagnostic signs
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- gitsigns
require("gitsigns").setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "契" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signcolumn = true,
})

-- indent-blankline (ibl) with theme-based highlights
local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "IblIndent", { fg = "#44475a" }) -- dim gray
  vim.api.nvim_set_hl(0, "IblScope", { fg = "#7aa2f7" })  -- scope highlight (blue-ish)
end)
require("ibl").setup({
  indent = { char = "│" },
  scope = { enabled = true, highlight = "IblScope" },
  exclude = { filetypes = { "help", "alpha", "dashboard", "NvimTree", "terminal", "lazy" } },
})

-- bufferline
require("bufferline").setup({
  options = { offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "left" } } }
})

-- =====================
-- 7) Telescope keymaps & setup
-- =====================
local telescope = require("telescope")
telescope.setup({
  defaults = { layout_config = { prompt_position = "top" }, sorting_strategy = "ascending" },
})
telescope.load_extension("fzf")
telescope.load_extension("file_browser")

-- Keymaps for telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
vim.keymap.set("n", "<leader>fe", ":Telescope file_browser<CR>", { desc = "File Browser" })

-- =====================
-- 8) Nvim-tree setup (filesystem)
-- =====================
require("nvim-tree").setup({
  view = { width = 30, side = "left" },
  renderer = { highlight_git = true, icons = { show = { git = true, folder = true, file = true } } },
  filters = { dotfiles = false },
})
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- =====================
-- 9) LSP setup (clangd & pyright)
-- =====================
local lspconfig = require("lspconfig")

-- attach function for keymaps
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

-- capabilities for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- servers
lspconfig.clangd.setup({ on_attach = on_attach, capabilities = capabilities })
lspconfig.pyright.setup({ on_attach = on_attach, capabilities = capabilities })

-- =====================
-- 10) Autocompletion (nvim-cmp)
-- =====================
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})


-- =====================
-- 11) ToggleTerm (integrated terminal)
-- =====================
require("toggleterm").setup({
  size = 15,                -- height in lines for horizontal terminal
  open_mapping = [[<C-\>]], -- Ctrl + \ toggles terminal
  shade_terminals = true,
  direction = "horizontal", -- can be "vertical", "float", or "tab"
  start_in_insert = true,
  persist_size = true,
  close_on_exit = true,
})

-- =====================
-- 12) AutoPairs (automatic brackets/quotes)
-- =====================
require("nvim-autopairs").setup({
  check_ts = true, -- enable treesitter integration
  disable_filetype = { "TelescopePrompt", "vim" },
})

-- =====================
-- 13) LSP: Lua (for editing Neovim config)
-- =====================
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

-- =====================
-- 14) Formatter setup
-- =====================
require("conform").setup({
  formatters_by_ft = {
    python = { "black" },
    cpp = { "clang-format" },
    c = { "clang-format" },
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
  },
  format_on_save = { timeout_ms = 1000, lsp_fallback = true },
})

-- =====================
-- 15) Statusline (lualine)
-- =====================
require("lualine").setup({
  options = { theme = "auto", section_separators = "", component_separators = "" },
})

-- =====================
-- 16) Debugger (DAP + UI)
-- =====================
local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- Auto-open UI when debugging starts
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- Keymaps
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })

-- =====================
-- 17) Sessions & Workspaces
-- =====================
require("auto-session").setup({
  auto_restore_enabled = true,
  auto_session_suppress_dirs = { "~/", "/" },
})

require("workspaces").setup({
  hooks = {
    open = { "NvimTreeOpen" },
  },
})

-- Keymaps
vim.keymap.set("n", "<leader>pw", ":WorkspacesOpen<CR>", { desc = "Open Workspaces" })
vim.keymap.set("n", "<leader>ps", ":SessionSave<CR>", { desc = "Save Session" })
vim.keymap.set("n", "<leader>pr", ":SessionRestore<CR>", { desc = "Restore Session" })
