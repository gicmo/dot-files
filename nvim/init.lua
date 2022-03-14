-- NeoVim configuration

-- plugins
local packer_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. packer_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
    
  -- themes
  use 'arcticicestudio/nord-vim'
end)

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

-- identing
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smarttab = true
vim.o.autoindent = true

