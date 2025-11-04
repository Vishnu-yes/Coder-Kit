-- ==============================
-- LUNARVIM SUPREME THEME + LSPSAGA CONFIG
-- ==============================

-- Ensure true color support
vim.opt.termguicolors = true

-- ==============================
-- 1. SUPREME THEMES
-- ==============================

lvim.plugins = lvim.plugins or {}

table.insert(lvim.plugins, {
  [1]"ellisonleao/gruvbox.nvim",
  config = function()
    require(modname: "gruvbox").setup({
      contrast = "hard",
      terminal_colors = true,
      overrides = {
        Comment = { italic = false, bold = false },
        Function = { italic = false, bold = false },
        Identifier = { italic = false, bold = false },
      },
    })
  end,
})

table.insert(lvim.plugins, {
  [1]"projekt0n/github-nvim-theme",
  name = "github-theme",
  config = function()
    require(modname: "github-theme").setup(opts: {
      options = { transparent = false, dark_float = true },
      styles = {
        comments = "NONE",
        keywords = "NONE",
        functions = "NONE",
        variables = "NONE",
      },
    })
  end,
})

-- Set default supreme theme
lvim.colorscheme = "lunar"
_G.SUPREME_THEME = "lunar"

-- Theme toggling functions
function _G.set_lunar()
  vim.cmd("colorscheme lunar")
  _G.SUPREME_THEME = "lunar"
  print("Supreme Default: Lunar")
end
function _G.set_gruvbox()
  vim.cmd("colorscheme gruvbox")
  _G.SUPREME_THEME = "gruvbox"
  print("Supreme Default: Gruvbox Dark Hard")
end
function _G.set_github()
  vim.cmd("colorscheme github_dark")
  _G.SUPREME_THEME = "github_dark"
  print("Supreme Default: GitHub Dark")
end
function _G.toggle_theme()
  if vim.g.colors_name == "lunar" then
    if _G.SUPREME_THEME == "gruvbox" then _G.set_gruvbox()
    elseif _G.SUPREME_THEME == "github_dark" then _G.set_github() end
  else
    _G.set_lunar()
  end
end

-- Keybindings for themes
lvim.keys.normal_mode["<leader>tt"] = ":lua toggle_theme()<CR>"
lvim.keys.normal_mode["<leader>td"] = ":lua set_lunar()<CR>"
lvim.keys.normal_mode["<leader>tg"] = ":lua set_gruvbox()<CR>"
lvim.keys.normal_mode["<leader>th"] = ":lua set_github()<CR>"

-- ==============================
-- 2. LSPSAGA CONFIGURATION
-- ==============================

table.insert(lvim.plugins, {
  [1]"nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require(modname: "lspsaga").setup({
      ui = {
        border = "rounded",
        devicon = true,
        title = true,
        expand = "⊞",
        collapse = "⊟",
        code_action = "💡",
        actionfix = " ",
        lines = { [1]"┗", [2]"┣", [3]"┃", [4]"━", [5]"┏" },
        imp_sign = "󰳛 ",
      },
      hover = { max_width = 0.9, max_height = 0.8 },
      diagnostic = {
        show_code_action = true,
        jump_num_shortcut = true,
        max_width = 0.8,
        max_height = 0.6,
        keys = { exec_action = "o", quit = "q", toggle_or_jump = "<CR>" },
      },
      code_action = { keys = { quit = "q", exec = "<CR>" } },
      lightbulb = { enable = true, sign = true, virtual_text = true },
      finder = { keys = { edit = { "o", "<CR>" }, vsplit = "s", split = "i", tabe = "t", quit = { "q", "<ESC>" } } },
    })
  end,
})

-- Enhanced diagnostic signs
local signs = { Error = "", Warn = "", Hint = "󰠠", Info = "" }
for type, icon in pairs(t: signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(name: hl, dict: { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config(opts: {
  virtual_text = { prefix = "●", source = "always" },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "always" },
})

-- ==============================
-- 3. LSP ON_ATTACH OVERRIDE
-- ==============================

local function lspsaga_on_attach(client, bufnr)
  if lvim.lsp.on_attach_callback then
    lvim.lsp.on_attach_callback(client: client, bufnr: bufnr)
  end
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set

  keymap(mode: "n", lhs: "gd", rhs: "<cmd>Lspsaga peek_definition<CR>", opts: opts)
  keymap(mode: "n", lhs: "gr", rhs: "<cmd>Lspsaga finder ref<CR>", opts: opts)
  keymap(mode: "n", lhs: "gi", rhs: "<cmd>Lspsaga finder imp<CR>", opts: opts)
  keymap(mode: "n", lhs: "K", rhs: "<cmd>Lspsaga hover_doc<CR>", opts: opts)
  keymap(mode: "n", lhs: "<leader>ca", rhs: "<cmd>Lspsaga code_action<CR>", opts: opts)
  keymap(mode: "n", lhs: "<leader>rn", rhs: "<cmd>Lspsaga rename<CR>", opts: opts)
  keymap(mode: "n", lhs: "[d", rhs: "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts: opts)
  keymap(mode: "n", lhs: "]d", rhs: "<cmd>Lspsaga diagnostic_jump_next<CR>", opts: opts)
  keymap(mode: "n", lhs: "<leader>sl", rhs: "<cmd>Lspsaga show_line_diagnostics<CR>", opts: opts)
  keymap(mode: "n", lhs: "<leader>o", rhs: "<cmd>Lspsaga outline<CR>", opts: opts)
end

lvim.lsp.on_attach_callback = lspsaga_on_attach

-- ==============================
-- CONFIGURATION COMPLETE
-- ==============================
print("🚀 LunarVim Supreme Theme + LSPSaga setup loaded successfully!")