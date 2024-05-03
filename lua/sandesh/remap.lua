vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>rp", vim.cmd.DapToggleRepl)
-- Still need to figure out the best mapping for autocomplete
-- vim.keymap.set('i', '<C-Space>', '<cmd>lua vim.lsp.buf.completion()<CR>', opts)
vim.keymap.set('n', '<leader>fc', "<cmd>!cp '%:p' '%:p:h/%:t:r-copy.%:e'<CR>", opts)
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, { buffer = args.buf })
		vim.keymap.set('n', '<leader>rf',  function() 
			local wordToRename = vim.fn.expand("<cword>")
			vim.lsp.buf.rename(vim.fn.input({prompt='Rename "' .. wordToRename .. '" to: '})) 
		end)
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
	end,
})

-- Center the screen while navigating 
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("n", "j", "jzz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", ")", ")zz")
vim.keymap.set("n", "(", "(zz")

vim.keymap.set("n", "<S-l>", "<cmd>:cnext<CR>")
vim.keymap.set("n", "<S-h>", "<cmd>:cprev<CR>")

-- vim rest conosole
vim.keymap.set("n", "<leader>xr", ":call VrcQuery()<CR>")
-- Checkbox
vim.keymap.set("n", "<leader>ch", "<cmd>:ToggleCheckbox<CR>")
-- Execute current shell script
vim.keymap.set("n", "<leader>xs", ":!%:p<CR>")
vim.keymap.set("n", "<leader>qs",function ()
  local quickfix_list = vim.fn.getqflist()
    table.sort(quickfix_list, function(a, b)
        return a.text < b.text
    end)
    vim.fn.setqflist(quickfix_list)
end)
