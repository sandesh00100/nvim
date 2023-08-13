local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function () builtin.find_files({wrap_results=true}) end)
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
-- Git file search, where you only find files in your git repo
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- Grep string, probably will be faster 
vim.keymap.set('n', '<leader>ps',function() 
	builtin.grep_string({search = vim.fn.input("Grep > ")})
end)

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
		vim.keymap.set('n', '<leader>rf', function ()
			local previousName = vim.fn.expand("<cword>");
			vim.lsp.buf.rename(vim.fn.input({prompt="Rename '" .. previousName .. "' to: " }))	
		end)
	end,
})
vim.keymap.set('n', 'gr', function () builtin.lsp_references({preview=true}) end)
vim.keymap.set('n', 'gi', function () builtin.lsp_implementation() end)
vim.keymap.set('n', '<leader>hi', function () builtin.lsp_incoming_calls() end)
vim.keymap.set('n', '<leader>ho', function () builtin.lsp_outgoing_calls() end)
vim.keymap.set('n', '<leader>mt', function () builtin.treesitter({default_text=":method:"}) end)
vim.keymap.set('n', '<leader>ft', function () builtin.treesitter() end)
