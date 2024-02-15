vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gtd", vim.cmd.Gdiffsplit)
vim.keymap.set("n", "<leader>gtw", vim.cmd.Gwrite)

-- Still need to figure out what this does
vim.keymap.set("n", "<leader>gtr", vim.cmd.Gread)

vim.api.nvim_set_keymap('n', '<leader>gl', ':Git log<CR>', { noremap = true, desc="View Git logs"})
vim.api.nvim_set_keymap('n', '<leader>gb', ':Git blame<CR>', { noremap = true, desc="Git blame"})
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit<CR>', { noremap = true, desc="Git Commit files"})
vim.api.nvim_set_keymap('n', '<leader>gl', ':Git log<CR>', { noremap = true, desc="View Git logs"})

vim.api.nvim_set_keymap('n', '<leader>gp', ':Git pull --rebase origin main<CR>', { noremap = true, desc="Git pull with rebase"})
vim.api.nvim_set_keymap('n', '<leader>gh', ':Git push<CR>', { noremap = true, desc="Git push"})
