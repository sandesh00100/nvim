local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
-- Git file search, where you only find files in your git repo
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- Grep string
vim.keymap.set('n', '<leader>ps',function() 
	builtin.grep_string({search = vim.fn.input("Grep > ")})
end)
