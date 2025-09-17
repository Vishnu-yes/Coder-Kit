
    vim.env.PATH = vim.env.HOME .. "/.cargo/bin:" .. vim.env.PATH                                                                                             vim.env.PATH = vim.env.HOME .. "/.npm-global/bin:" .. vim.env.PATH
    vim.env.PATH = "/data/data/com.termux/files/usr/bin:" .. vim.env.PATH  --- This is where python fplder exists in the termux bin without it pyright can not run!
    -- Bootstrap lazy.nvim
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

    -- Basic settings
    vim.o.number = false
    vim.o.relativenumber = false
    vim.o.cursorline = false
    vim.o.termguicolors = true -- enable true color support

    print("Neovim Lua config loaded!")

    -- Plugins
require("lazy").setup({

  -- Theme
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    priority = 1000,
    config = function()
      local current_style = "light_default"

      local function set_github_theme(style)
        require("github-theme").setup({
          options = { transparent = false },
          styles = { comments = "NONE", keywords = "NONE", functions = "NONE", variables = "NONE" },
        })
        vim.cmd("colorscheme github_" .. style)
      end

      set_github_theme(current_style)

      _G.ToggleGithubTheme = function()
        if current_style == "light_default" then
          current_style = "dark_default"
        else
          current_style = "light_default"
        end
        set_github_theme(current_style)
        print("GitHub theme switched to: " .. current_style)
      end

      vim.api.nvim_set_keymap("n", "<leader>gt", ":lua ToggleGithubTheme()<CR>", { noremap = true, silent = true })
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Completion
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
        mapping = cmp.mapping.preset.insert({ ["<CR>"] = cmp.mapping.confirm({ select = true }) }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" } }),
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

-- LSP
    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local on_attach = function(_, bufnr)
          local opts = { noremap = true, silent = true, buffer = bufnr }
          local keymap = vim.keymap.set

          keymap("n", "gd", vim.lsp.buf.definition, opts)
          keymap("n", "K", vim.lsp.buf.hover, opts)
          keymap("n", "gi", vim.lsp.buf.implementation, opts)
          keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
          keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          keymap("n", "gr", vim.lsp.buf.references, opts)
          keymap("n", "[d", function() vim.diagnostic.goto_prev({ float = false }) end, opts)
          keymap("n", "]d", function() vim.diagnostic.goto_next({ float = false }) end, opts)
        end

        -- C/C++ (clangd)
        lspconfig.clangd.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { "clangd", "--background-index", "--clang-tidy" },
          root_dir = function(fname)
            return lspconfig.util.root_pattern(
              "compile_commands.json", "compile_flags.txt", ".git"
            )(fname) or vim.fn.getcwd()
          end,
        })
        -- Python (Pyright)
        lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "/data/data/com.termux/files/usr/bin/pyright-langserver", "--stdio" },
        settings = {
            python = {pythonPath = "/home/you/Python/venv/bin/python",  -- your venv                                                                              }
    }
})

        -- Python (Pyright)
        lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
         settings = {
             python = {
                 pythonPath = "/home/you/Python/venv/bin/python",  -- point to your venv
             }
         }
     })
       ------------ All lsps will be inside this and bot out of this
       ---
       ---

        -- existing LSP setups ...
        lspconfig.asm_lsp.setup({
          cmd = { "/data/data/com.termux/files/usr/bin/asm-lsp", "--config", "/data/data/com.termux/files/home/.asm-lsp.toml" },
          filetypes = { "asm", "nasm", "x86asm", "s" },
          root_dir = lspconfig.util.root_pattern(".git", "."),
        })

        -- Add JS, CSS, HTML LSPs
        -- New (ts_ls)
        lspconfig.ts_ls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })

        lspconfig.cssls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
        lspconfig.html.setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
        ------ new lsps begins here

        -----
        ---
        ---
        ---

       ------------ All lsps will be inside this and bot out of this some can be but not the newer                                                        
        -- Lua                                                                                                                                                    lspconfig.lua_ls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        })

        -- Nasm x64 Assembly (asm-lsp)
        lspconfig.asm_lsp.setup({
          cmd = {
            "/data/data/com.termux/files/usr/bin/asm-lsp",
            "--config", "/data/data/com.termux/files/home/.asm-lsp.toml",
          },
          filetypes = { "asm", "nasm", "x86asm", "s" },
          root_dir = lspconfig.util.root_pattern(".git", "."),
        })

        -- Diagnostic config
        vim.diagnostic.config({
          virtual_text = true,
          signs = true,
          underline = true,
          update_in_insert = false,
          severity_sort = true,
        })

        vim.cmd("highlight DiagnosticError guifg=#fb4934 gui=bold")
        vim.cmd("highlight DiagnosticWarn guifg=#fabd2f gui=bold")
        vim.cmd("highlight DiagnosticInfo guifg=#83a598 gui=italic")
        vim.cmd("highlight DiagnosticHint guifg=#b8bb26 gui=italic")
      end,
    },

  -- ARM64 assembly syntax highlighting
  {
    "Shirk/vim-gas",
    ft = { "asm", "s" },
  },

  -- ARM64 assembly linting
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters.as = {
        name = "as",
        cmd = "as",
        args = { "-o", "/dev/null", "%f" },
        stdin = false,
        stream = "stderr",
        parser = require("lint.parser").from_errorformat("%f:%l: %m", {}),
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*.s" },
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
  ---- Nasm
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "asm", "c", "lua" },
        sync_install = false,
        auto_install = false, -- we already have everything
        ignore_install = {},
        modules = {},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },

  -- Syntax highlighting and linting using system NASM
  {                                                                                                                                                           "dense-analysis/ale",
    lazy = false,
    config = function()
      vim.g.ale_linters = {
        asm = {"nasm"} -- use system-installed nasm
      }
    end
  },

  -- Terminal integration for QEMU
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup{
        size = 20,
        open_mapping = [[<c-\>]],
        shading_factor = 2,
        direction = "horizontal",
      }
    end
  },

  -- Optional: Snippets for assembly
  {
    "honza/vim-snippets",
    lazy = false,
    ft = {"asm", "nasm", "x86asm"},
  },
})


-- Add custom filetype detection for assembly
vim.filetype.add({
    extension = {
        s    = "gas",   -- standard GAS assembly
        asm  = "nasm",  -- NASM assembly
        nasm = "nasm",
        x86  = "nasm",  -- optional, if you name files like *.x86
    },
})



    -- Filetype-specific indentation (moved OUTSIDE plugin spec)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "c", "cpp", "python", "lua" },
      callback = function()
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
      end,
    })
