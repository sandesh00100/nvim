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
-- Hier incoming calls
vim.keymap.set('n', '<leader>hi', function () builtin.lsp_incoming_calls() end)
-- Hier outgoing calls
vim.keymap.set('n', '<leader>ho', function () builtin.lsp_outgoing_calls() end)
-- Method tree
vim.keymap.set('n', '<leader>mt', function () builtin.treesitter({default_text=":method:"}) end)
-- File tree
vim.keymap.set('n', '<leader>ft', function () builtin.treesitter() end)
-- Diagnostics open
vim.keymap.set('n', '<leader>do', function () builtin.diagnostics() end)
-- Diagnostics errors
vim.keymap.set('n', '<leader>de', function () builtin.diagnostics({default_text=":E:", initial_mode="normal"}) end)
-- Diagnostics warn
vim.keymap.set('n', '<leader>dw', function () builtin.diagnostics({default_text=":W:", initial_mode="normal"}) end)
-- Diagnostics info
vim.keymap.set('n', '<leader>di', function () builtin.diagnostics({default_text=":I:", initial_mode="normal"}) end)
