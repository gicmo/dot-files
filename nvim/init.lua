-- NeoVim configuration


-- editor
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- options

vim.o.encoding = "utf-8"
vim.o.spell = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true

vim.o.completeopt = 'noinsert,menuone,noselect'

vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

-- visuals
vim.o.modeline = true
vim.o.ruler = true
vim.o.showmatch = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false

vim.cmd [[colorscheme nord]]

-- indenting
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smarttab = true
vim.o.autoindent = true

