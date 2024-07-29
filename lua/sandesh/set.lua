vim.o.rnu = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.spell = true

vim.o.background = "dark" -- or "light" for light mode
vim.o.clipboard = "unnamed" -- or "light" for light mode
vim.cmd([[colorscheme everforest]])
vim.opt.guifont='Hack NFM'

vim.o.expandtab = true
vim.o.cursorline = true
vim.opt.conceallevel = 2
vim.opt.showmode = false
vim.cmd("hi Search guibg=peru")
vim.o.textwidth=120
-- Global settings
vim.opt.tabstop = 2       -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2    -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true  -- Use spaces instead of tabs
vim.opt.softtabstop = 2   -- Number of spaces that a <Tab> counts for while performing editing operations
vim.opt.autoindent = true -- Copy indent from current line when starting a new line
vim.opt.smartindent = true -- Make indenting smart
-- Custom highlight groups
vim.api.nvim_set_hl(0, 'question', { fg = "#FEFEFE", bg = "#875201" })

