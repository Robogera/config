vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.encoding = 'utf-8'
vim.opt.backspace = 'indent,eol,start'
vim.opt.startofline = true
vim.opt.timeout = true
vim.o.timeoutlen = 600
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 100
vim.opt.showmatch = true
vim.opt.scrolloff = 12
vim.opt.list = false
vim.opt.foldenable = false
vim.opt.wrap = true
vim.cmd(':set linebreak breakindent')
vim.opt.eol = false
vim.opt.showbreak = '↪ '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.signcolumn = 'yes'
vim.opt.modelines = 0
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.matchtime = 1
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.swapfile = false
vim.opt.wildmenu = true
vim.opt.conceallevel = 1
vim.opt.updatetime = 300

-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'


-- Plugin manager
require('config.lazy')

-- Diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'er',
      [vim.diagnostic.severity.WARN] = 'wa',
      [vim.diagnostic.severity.HINT] = 'hi',
      [vim.diagnostic.severity.INFO] = 'in',
    }
  }
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostics' })

-- Neovide GUI
if vim.g.neovide then
  if vim.fn.hostname() == 'HOMESTATION' then
    vim.o.guifont = 'Iosevka Nerd Font Mono:h14'
  elseif vim.fn.hostname() == 'workstation' then
    vim.o.guifont = 'Iosevka Nerd Font:h14'
  end
end
