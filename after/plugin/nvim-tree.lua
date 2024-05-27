-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.keymap.set("n", "<leader>nf", vim.cmd.NvimTreeFindFile)
vim.keymap.set("n", "<leader>nt", vim.cmd.NvimTreeToggle)
