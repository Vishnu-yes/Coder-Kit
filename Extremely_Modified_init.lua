-- ==============================
-- NEOVIM CONFIGURATION INIT.LUA
-- ==============================
-- Table of Contents:
-- 1. Leader Keys Setup
-- 2. Environment Configuration  
-- 3. Plugin Manager Bootstrap
-- 4. Basic Editor Settings
-- 5. Plugin Configurations
--    - Themes (Gruvbox, GitHub)
--    - Editor Enhancement (Autopairs, Completion)
--    - LSP Enhancement (LSPSaga)
--    - Syntax Highlighting (Treesitter)
--    - Terminal Integration (Toggleterm)
--    - File Navigation (Telescope)
--    - Language Support (Snippets)
-- 6. LSP Server Configurations
-- 7. UI & Diagnostics Customization
-- 8. Filetype Specific Settings
-- ==============================

-- ==============================
-- 1. LEADER KEYS (Set Early)
-- ==============================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ==============================
-- 2. ENVIRONMENT PATHS
-- ==============================
vim.env.PATH = table.concat({
  "/data/data/com.termux/files/usr/bin",
  vim.env.HOME .. "/.cargo/bin",
  vim.env.HOME .. "/.npm-global/bin",
  vim.env.PATH
}, ":")

-- ==============================
-- 3. BOOTSTRAP LAZY.NVIM PLUGIN MANAGER
-- ==============================
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

-- ==============================
-- 4. BASIC EDITOR SETTINGS
-- ==============================
vim.o.number = false
vim.o.relativenumber = false
vim.o.cursorline = false
vim.o.termguicolors = true
print("Neovim Lua config loaded!")

-- ==============================
-- 5. PLUGIN SETUP & CONFIGURATIONS
-- ==============================
require("lazy").setup({

  -- ==============================
  -- 5.1 THEME: GRUVBOX
  -- ==============================
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        contrast = "hard",
      })
    end,
  },

  -- ==============================
  -- 5.2 THEME: GITHUB
  -- ==============================
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    priority = 999,
    config = function()
      local current_theme = "gruvbox_dark_hard"

      -- Theme switching functions
      local function set_gruvbox_theme(style)
        require("gruvbox").setup({ contrast = "hard" })
        vim.o.background = style
        vim.cmd("colorscheme gruvbox")
      end

      local function set_github_theme(style)
        require("github-theme").setup({
          options = { transparent = false },
          styles = { comments = "NONE", keywords = "NONE", functions = "NONE", variables = "NONE" },
        })
        vim.cmd("colorscheme github_" .. style)
      end

      -- Global theme switching functions
      _G.t1 = function() current_theme = "gruvbox_dark_hard"; set_gruvbox_theme("dark"); print("Theme: Gruvbox Dark Hard") end
      _G.t2 = function() current_theme = "gruvbox_light_hard"; set_gruvbox_theme("light"); print("Theme: Gruvbox Light Hard") end
      _G.t3 = function() current_theme = "github_dark"; set_github_theme("dark_default"); print("Theme: GitHub Dark") end
      _G.t4 = function() current_theme = "github_light"; set_github_theme("light_default"); print("Theme: GitHub Light") end

      -- Initialize theme
      if current_theme == "gruvbox_dark_hard" then _G.t1()
      elseif current_theme == "gruvbox_light_hard" then _G.t2()
      elseif current_theme == "github_dark" then _G.t3()
      elseif current_theme == "github_light" then _G.t4() end

      -- Theme switching keybindings
      vim.keymap.set("n", "<leader>gt", _G.t3, { noremap = true, silent = true, desc = "GitHub Dark Theme" })
      vim.keymap.set("n", "<leader>gl", _G.t4, { noremap = true, silent = true, desc = "GitHub Light Theme" })
    end,
  },

  -- ==============================
  -- 5.3 EDITOR ENHANCEMENT: AUTO PAIRS
  -- ==============================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- ==============================
  -- 5.4 COMPLETION ENGINE: NVIM-CMP
  -- ==============================
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({ 
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" }
        }),
      })

      -- Integration with autopairs
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ==============================
  -- 5.5 LSP CONFIGURATION: NVIM-LSPCONFIG
  -- ==============================
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
  },

  -- ==============================
  -- 5.6 LSP ENHANCEMENT: LSPSAGA
  -- ==============================
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lspsaga").setup({
        -- UI Configuration
        ui = {
          border = "rounded",
          devicon = true,
          title = true,
          expand = "⊞",
          collapse = "⊟",
          code_action = "💡",
          actionfix = " ",
          lines = { "┗", "┣", "┃", "━", "┏" },
          kind = {},
          imp_sign = "󰳛 ",
        },
        
        -- Hover Configuration
        hover = {
          max_width = 0.9,
          max_height = 0.8,
          open_link = "gx",
          open_cmd = "!chrome",
        },
        
        -- Diagnostic Configuration
        diagnostic = {
          show_code_action = true,
          show_layout = "float",
          show_normal_height = 10,
          jump_num_shortcut = true,
          max_width = 0.8,
          max_height = 0.6,
          max_show_width = 0.9,
          max_show_height = 0.6,
          text_hl_follow = true,
          border_follow = true,
          extend_relatedInformation = false,
          diagnostic_only_current = false,
          keys = {
            exec_action = "o",
            quit = "q",
            toggle_or_jump = "<CR>",
            quit_in_show = { "q", "<ESC>" },
          },
        },
        
        -- Code Action Configuration
        code_action = {
          num_shortcut = true,
          show_server_name = false,
          extend_gitsigns = true,
          only_in_cursor = true,
          max_height = 0.3,
          keys = {
            quit = "q",
            exec = "<CR>",
          },
        },
        
        -- Lightbulb Configuration
        lightbulb = {
          enable = true,
          enable_in_insert = true,
          sign = true,
          sign_priority = 40,
          virtual_text = true,
        },
        
        -- Preview Configuration
        preview = {
          lines_above = 0,
          lines_below = 10,
        },
        
        -- Scroll Preview Configuration
        scroll_preview = {
          scroll_down = "<C-f>",
          scroll_up = "<C-b>",
        },
        
        -- Request Timeout
        request_timeout = 2000,
        
        -- Finder Configuration
        finder = {
          max_height = 0.5,
          left_width = 0.4,
          methods = {},
          default = "ref+imp",
          layout = "float",
          silent = false,
          filter = {},
          fname_sub = nil,
          sp_inexist = false,
          sp_global = false,
          ly_botright = false,
          keys = {
            jump_to = "p",
            edit = { "o", "<CR>" },
            vsplit = "s",
            split = "i",
            tabe = "t",
            tabnew = "r",
            quit = { "q", "<ESC>" },
            close_in_preview = "<ESC>",
          },
        },
        
        -- Definition Configuration
        definition = {
          edit = "<C-c>o",
          vsplit = "<C-c>v",
          split = "<C-c>i",
          tabe = "<C-c>t",
          quit = "q",
          close = "<Esc>",
        },
        
        -- Rename Configuration
        rename = {
          quit = "<C-c>",
          exec = "<CR>",
          mark = "x",
          confirm = "<CR>",
          in_select = true,
          whole_project = true,
        },
        
        -- Outline Configuration
        outline = {
          win_position = "right",
          win_with = "",
          win_width = 30,
          preview_width = 0.4,
          show_detail = true,
          auto_preview = true,
          auto_refresh = true,
          auto_close = true,
          auto_resize = false,
          max_height = 0.5,
          left_width = 0.3,
          keys = {
            jump = "o",
            expand_collapse = "u",
            quit = "q",
          },
        },
        
        -- Callhierarchy Configuration
        callhierarchy = {
          show_detail = false,
          keys = {
            edit = "e",
            vsplit = "s",
            split = "i",
            tabe = "t",
            jump = "o",
            quit = "q",
            expand_collapse = "u",
          },
        },
        
        -- Symbol in Winbar
        symbol_in_winbar = {
          enable = false,
          separator = "  ",
          hide_keyword = true,
          show_file = true,
          folder_level = 2,
          respect_root = false,
          color_mode = true,
        },
        
        -- Beacon Configuration
        beacon = {
          enable = true,
          frequency = 7,
        },
      })
      
      -- LSPSaga Keybindings (Global)
      vim.keymap.set("n", "<leader>lf", "<cmd>Lspsaga finder<CR>", { desc = "LSP Finder" })
      vim.keymap.set("n", "<leader>lo", "<cmd>Lspsaga outline<CR>", { desc = "LSP Outline" })
      vim.keymap.set("n", "<leader>lci", "<cmd>Lspsaga incoming_calls<CR>", { desc = "LSP Incoming Calls" })
      vim.keymap.set("n", "<leader>lco", "<cmd>Lspsaga outgoing_calls<CR>", { desc = "LSP Outgoing Calls" })
    end,
  },

  -- ==============================
  -- 5.7 SYNTAX HIGHLIGHTING: TREESITTER
  -- ==============================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "asm", "c", "lua", "python", "javascript", "typescript", "html", "css" },
        sync_install = false,
        auto_install = false,
        highlight = { 
          enable = true, 
          additional_vim_regex_highlighting = false 
        },
        indent = { enable = true },
      })
    end,
  },

  -- ==============================
  -- 5.8 TERMINAL INTEGRATION: TOGGLETERM
  -- ==============================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        shading_factor = 2,
        direction = "horizontal",
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end,
  },

  -- ==============================
  -- 5.9 FILE NAVIGATION: TELESCOPE
  -- ==============================
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          prompt_prefix = "🔍 ",
          selection_caret = " ",
          layout_config = { 
            horizontal = { width = 0.9 }, 
            vertical = { preview_height = 0.4 } 
          },
          file_ignore_patterns = { "node_modules", ".git/" },
        },
        pickers = { 
          find_files = { hidden = true } 
        },
        extensions = { 
          fzf = { 
            fuzzy = true, 
            override_generic_sorter = true, 
            override_file_sorter = true, 
            case_mode = "smart_case" 
          } 
        },
      })

      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")

      -- Telescope keybindings
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
      vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "LSP Symbols" })
      vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Recent Files" })
      vim.keymap.set("n", "<leader>fe", telescope.extensions.file_browser.file_browser, { desc = "File Browser" })
    end,
  },

  -- ==============================
  -- 5.10 LANGUAGE SUPPORT: SNIPPETS
  -- ==============================
  {
    "honza/vim-snippets",
    lazy = false,
    ft = { "asm", "nasm", "x86asm", "c", "cpp", "python", "lua" },
  },

})

-- ==============================
-- 6. LSP SERVER CONFIGURATIONS
-- ==============================

-- Get LSP configuration and capabilities
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Enhanced LSP attach function with LSPSaga integration
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set

  -- LSP Navigation (Enhanced with LSPSaga)
  keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", vim.tbl_extend("force", opts, { desc = "Peek Definition" }))
  keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))
  keymap("n", "gi", "<cmd>Lspsaga finder imp<CR>", vim.tbl_extend("force", opts, { desc = "Find Implementations" }))
  keymap("n", "gr", "<cmd>Lspsaga finder ref<CR>", vim.tbl_extend("force", opts, { desc = "Find References" }))
  
  -- LSP Information & Documentation
  keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
  keymap("n", "<C-k>", "<cmd>Lspsaga hover_doc ++keep<CR>", vim.tbl_extend("force", opts, { desc = "Pin Hover Documentation" }))
  
  -- LSP Code Actions & Refactoring
  keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", vim.tbl_extend("force", opts, { desc = "LSP Rename" }))
  keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", vim.tbl_extend("force", opts, { desc = "Code Action" }))
  keymap("v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", vim.tbl_extend("force", opts, { desc = "Code Action" }))
  
  -- LSP Diagnostics Navigation
  keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))
  keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
  keymap("n", "[e", function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, vim.tbl_extend("force", opts, { desc = "Previous Error" }))
  keymap("n", "]e", function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, vim.tbl_extend("force", opts, { desc = "Next Error" }))
  
  -- LSP Diagnostics Display
  keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>", vim.tbl_extend("force", opts, { desc = "Line Diagnostics" }))
  keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", vim.tbl_extend("force", opts, { desc = "Cursor Diagnostics" }))
  keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", vim.tbl_extend("force", opts, { desc = "Buffer Diagnostics" }))
  
  -- LSP Workspace & Outline
  keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>", vim.tbl_extend("force", opts, { desc = "Toggle Outline" }))
  
  -- Additional LSP utilities
  keymap("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, vim.tbl_extend("force", opts, { desc = "Format Document" }))
  
  -- Enable inlay hints if supported
  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

-- LSP Server Configurations

-- Python (Pyright)
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "/data/data/com.termux/files/usr/bin/pyright-langserver", "--stdio" },
  settings = { 
    python = { 
      pythonPath = "/home/you/Python/venv/bin/python",
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      }
    } 
  },
})

-- TypeScript/JavaScript
lspconfig.ts_ls.setup({ 
  on_attach = on_attach, 
  capabilities = capabilities,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

-- CSS
lspconfig.cssls.setup({ 
  on_attach = on_attach, 
  capabilities = capabilities 
})

-- HTML
lspconfig.html.setup({ 
  on_attach = on_attach, 
  capabilities = capabilities 
})

-- C/C++ (Clangd)
lspconfig.clangd.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
  root_dir = function(fname)
    return lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname)
      or vim.fn.getcwd()
  end,
})

-- Lua
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { 
        globals = { "vim" } 
      },
      workspace = { 
        library = vim.api.nvim_get_runtime_file("", true), 
        checkThirdParty = false 
      },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
})

-- ==============================
-- 7. UI & DIAGNOSTICS CUSTOMIZATION
-- ==============================

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    enabled = true,
    source = "if_many",
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Custom diagnostic highlights
vim.cmd("highlight DiagnosticError guifg=#fb4934 gui=bold")
vim.cmd("highlight DiagnosticWarn guifg=#fabd2f gui=bold")
vim.cmd("highlight DiagnosticInfo guifg=#83a598 gui=italic")
vim.cmd("highlight DiagnosticHint guifg=#b8bb26 gui=italic")

-- ==============================
-- 8. FILETYPE SPECIFIC SETTINGS
-- ==============================

-- Assembly file type detection
vim.filetype.add({
  extension = {
    s    = "gas",
    asm  = "nasm",
    nasm = "nasm",
    x86  = "nasm",
  },
})

-- Programming language indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "python", "lua", "javascript", "typescript" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.expandtab = true
  end,
})

-- Markdown specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.colorcolumn = "81"
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
  end,
})

-- Assembly specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "asm", "nasm", "gas" },
  callback = function()
    vim.bo.shiftwidth = 8
    vim.bo.tabstop = 8
    vim.bo.expandtab = false
    vim.opt_local.commentstring = "; %s"
  end,
})

-- ==============================
-- CONFIGURATION COMPLETE
-- ==============================
-- Your enhanced Neovim configuration is now loaded!
-- Key improvements:
-- - Modern LSPSaga configuration with comprehensive settings
-- - Enhanced keybindings with descriptions
-- - Better organized sections with clear navigation
-- - Additional LSP features like inlay hints
-- - Improved diagnostic display and navigation
-- - Extended language support and filetype settings
-- ==============================
