vim.keymap.set("n", "<leader>gts", vim.cmd.Git)
vim.keymap.set("n", "<leader>gtd", vim.cmd.Gdiffsplit)
vim.keymap.set("n", "<leader>gtw", vim.cmd.Gwrite)

-- Still need to figure out what this does
vim.keymap.set("n", "<leader>gtr", vim.cmd.Gread)

vim.api.nvim_set_keymap('n', '<leader>gtl', ':Git log<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gtb', ':Git blame<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gtc', ':Git commit<CR>', { noremap = true})

vim.api.nvim_set_keymap('n', '<leader>grb', ':Git pull --rebase origin main<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gth', ':Git push<CR>', { noremap = true})
