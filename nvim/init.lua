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
    "scottmckendry/cyberdream.nvim",
    dependencies = {
      {"nvim-lualine/lualine.nvim"},
    },
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent = true,
        italic_comments = true,
        hide_fillchars = true,
        borderless_telescope = false,
        terminal_colors = true,
      })
      local cyberdream = require("lualine.themes.cyberdream")
      require("lualine").setup({
        dependencies = {
          'kyazdani42/nvim-web-devicons',
        },
        options = {
          theme = "cyberdream",
        },
      })
        vim.cmd("colorscheme cyberdream")
    end,
  },

  -- essentials
  'editorconfig/editorconfig-vim',

  -- navigation
  'tpope/vim-rsi',
  'tpope/vim-vinegar',

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 
      {'nvim-telescope/telescope-fzy-native.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'kyazdani42/nvim-web-devicons'}
    },
    
    opts = {
      defaults = {
        prompt_prefix = "→ ",
        selection_caret = "→ ",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",
        color_devicons = true,
        winblend = 0
      },

      extensions = {
        fzy_native = {
          override_file_sorter = true,
          override_generic_sorter = true,
        },

        fzf_writer = {
          use_highlighter = false,
          minimum_grep_characters = 6,
        }
      },
    },

    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = "Find Files" },
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = "Switch Buffer"},
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = "Find in Files"},
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
      { '<leader>xg', '<cmd>Neogit<CR>', desc='NeoGit' }
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
    "L3MON4D3/LuaSnip",
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function() 
      local cmp = require 'cmp'
      local lspkind = require("lspkind")
      return {
        mapping = {
          ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
          ['<Down>'] = cmp.mapping.select_next_item(select_opts),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),

          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        },
        window = {
          documentation = cmp.config.window.bordered()
        },
        formatting = {
          format = lspkind.cmp_format({
                    maxwidth = 50,
                    ellipsis_char = "...",
          }),
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
        },
        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
          }),
          scrollbar = false,
        },
      }
    end
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },

    opts = {
      on_attach = function(bufnr)
        local function map(mode, lhs, rhs, opts)
          opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
          vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end

        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings
        map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
        map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
        map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
        map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
        map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
        map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
        map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
        map('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
        map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
        map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
        map('n', '<leader>F', '<cmd>lua vim.lsp.buf.formatting()<CR>')

      end 
    },

    config = function(_, opts)
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " } 
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require('lspconfig')

      local servers = { 'gopls', 'pyright', 'sourcekit' }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end
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
  }

})

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

