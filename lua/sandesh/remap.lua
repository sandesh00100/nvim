vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- If you're motioning to a H or L then it can get tricky
vim.keymap.set("n", "<leader>h", "^")
vim.keymap.set("n", "<leader>l", "$")
