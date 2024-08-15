vim.o.rnu = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.spell = true

vim.o.background = "dark" -- or "light" for light mode
vim.o.clipboard = "unnamed" -- or "light" for light mode
vim.cmd([[colorscheme nordic]])
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
vim.api.nvim_set_hl(0, 'questioncustom', { fg = "#FEFEFE", bg = "#875201" })
vim.api.nvim_set_hl(0, 'todocustom', { fg = "#000000", bg = "#87CEEB" })
vim.api.nvim_set_hl(0, 'Visual', { fg = "#FEFEFE", bg = "#356063" })
vim.api.nvim_set_hl(0, 'fixmecustom', { fg = "#000000", bg = "#E9A1A1" })
vim.api.nvim_set_hl(0, 'CurSearch', { fg = "#FEFEFE", bg = "#6B0809", bold = true, underline = true})
vim.api.nvim_set_hl(0, 'Search', { fg = "#000000", bg = "#E9A1A1" })
 
vim.keymap.set("n", "<leader>bp", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
vim.keymap.set("n", "<F5>", "<cmd>lua require'dap'.continue()<cr>")
vim.keymap.set("n", "<F7>", "<cmd>lua require'dap'.step_into()<cr>")
vim.keymap.set("n", "<F8>", "<cmd>lua require'dap'.step_over()<cr>")
vim.keymap.set("n", "<F9>", "<cmd>lua require'dap'.step_out()<cr>")
