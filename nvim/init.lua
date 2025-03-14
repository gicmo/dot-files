-- editor options

vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- plugin manager

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- main colorscheme
  {
    "NTBBloodbath/doom-one.nvim",
    dependencies = {
      {"nvim-lualine/lualine.nvim"},
    },
    lazy = false,
    init = function()
      vim.g.doom_one_cursor_coloring = false
      vim.g.doom_one_terminal_colors = true
      vim.g.doom_one_enable_treesitter = true
      vim.g.doom_one_diagnostics_text_color = false
      vim.g.doom_one_transparent_background = false
      vim.g.doom_one_plugin_gitsigns = true
      vim.g.doom_one_plugin_neogit = true
      vim.g.doom_one_plugin_telescope = true
      vim.g.doom_one_plugin_whichkey = true
    end,
    config = function()
      vim.cmd("colorscheme doom-one")
      require("lualine").setup({
        dependencies = {
          'kyazdani42/nvim-web-devicons',
        },
      })
    end,
  },
  -- essentials
  'editorconfig/editorconfig-vim',
  'ntpeters/vim-better-whitespace',

  -- navigation
  'tpope/vim-rsi',
  'tpope/vim-vinegar',

  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      explorer = {},
      picker = {},
      quickfile = {},
    },
    keys = {
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fs", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },

      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },

      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    }
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = { max_lines = 1 },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
  },

  -- git
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    opts = {
      on_attach = function(bufnr)
        local function map(mode, lhs, rhs, opts)
          opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
          vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
        map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

        -- Actions
        map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
        map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
        map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
        map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
        map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
        map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
        map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
        map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
        map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

        -- Text object
        map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    },
  },
  {
    'TimUntersberger/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      disable_hint = true,
      graph_style = "kitty",
      kind = "replace",
      commit_popup = {
        kind = "vsplit",
      },
      signs = {
        section = { "▸", "▾" },
        item = { "▸", "▾" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      }
    },
    keys = {
      { '<leader>gg', '<cmd>Neogit<CR>', desc='NeoGit' }
    }
  },
  {
    'akinsho/git-conflict.nvim',
    opts = {
      default_mappings = true,
      disable_diagnostics = false,
      highlights = {
        incoming = 'DiffText',
        current = 'DiffAdd',
      }
    },
  },
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
  },

  -- autocomplete and snippets
  {
    'saghen/blink.cmp',
    version = 'v0.11.0',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = 'default' },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
    opts_extend = { "sources.default" }
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = { 'saghen/blink.cmp' },
    event = { "BufReadPre", "BufNewFile" },

    opts = {
      on_attach = function(bufnr)
        local function map(mode, lhs, rhs, opts)
          opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
          vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end

        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings
        -- map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
        -- map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
        map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
        map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
        map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
        map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
        map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
        map('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
        map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
        map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        -- map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
        map('n', '<leader>F', '<cmd>lua vim.lsp.buf.formatting()<CR>')

      end
    },

    config = function(_, opts)
      local signs = { Error = "", Warn = "", Hint = "󰌶", Info = "󰋽" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
      end


      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require('lspconfig')

      local servers = { 'gopls', 'pyright', 'sourcekit' }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end

      lspconfig.sourcekit.setup {
        filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objc', 'objective-cpp' },
        on_init = function(client, initialization_result)
          if client.server_capabilities then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
        get_language_id = function(_, ftype)
          if ftype == "objc" then
            return "objective-c"
          elseif ftype == "objcpp" then
            return "objective-cpp"
          end
          return ftype
        end,
      }
    end
  },

  keys = {
    { '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>' },
    { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>' },
    { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>' },
    { '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>' },
  },

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then
            require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          end
        end,
      },
    },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },

    opts = {
      ensure_installed = "all",

      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      indent = {
        enable = true
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end
  },

  -- markdown
  {
    'MeanderingProgrammer/markdown.nvim',
    main = "render-markdown",
    opts = {},
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.icons'
    },
  },
})

vim.o.clipboard = "unnamedplus"

vim.o.encoding = "utf-8"
vim.o.spell = true
vim.o.spelloptions = 'camel,noplainbuffer'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true

vim.o.completeopt = 'noinsert,menuone,noselect'

vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

-- visuals
vim.o.nu = true
vim.o.relativenumber = true

vim.o.modeline = true
vim.o.ruler = true
vim.o.showmatch = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false

-- indenting
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smarttab = true
vim.o.autoindent = true

