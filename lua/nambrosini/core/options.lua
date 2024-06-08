vim.cmd("let g:netrw_lifestyle = 3")

local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- show color column
opt.colorcolumn = "120"

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- Don't show mode
vim.opt.showmode = false

-- Ignore stuff
vim.cmd("let g:loaded_node_provider=0")
vim.cmd("let g:loaded_perl_provider=0")
vim.cmd("let g:loaded_python3_provider=0")
vim.cmd("let g:loaded_ruby_provider=0")
