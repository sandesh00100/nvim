vim.keymap.set("n", "<leader>cgp", vim.cmd.ChatGPT)
vim.keymap.set("v", "<leader>cgi", vim.cmd.ChatGPTEditWithInstructions)
vim.api.nvim_set_keymap('v', '<leader>cgc', ':ChatGPTRun complete_code<CR>', { noremap = true})
vim.api.nvim_set_keymap('v', '<leader>cgc', ':ChatGPTRun complete_code<CR>', { noremap = true})
