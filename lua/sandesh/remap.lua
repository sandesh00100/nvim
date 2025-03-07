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

vim.keymap.set("n", "<ESC>", "<cmd>:noh<CR>")

vim.keymap.set("n", "<S-l>", "<cmd>:cnext<CR>")
vim.keymap.set("n", "<S-h>", "<cmd>:cprev<CR>")

-- vim rest conosole
vim.keymap.set("n", "<leader>xr", ":call VrcQuery()<CR>")
-- Execute current shell script
vim.keymap.set("n", "<leader>xs", ":!%:p<CR>")

vim.keymap.set("n", "<leader>qs",function ()
  local quickfix_list = vim.fn.getqflist()
    table.sort(quickfix_list, function(a, b)
        return a.lnum < b.lnum
    end)
    vim.fn.setqflist(quickfix_list)
end)

vim.keymap.set("n", "<leader>qa",function ()
  local quickfix_list = vim.fn.getqflist()
  local cfilename = vim.fn.expand('%:p')
  local cursorrow = vim.api.nvim_win_get_cursor(0)[1]
  local cursorcol = vim.api.nvim_win_get_cursor(0)[2] + 1
  local bufnr = vim.api.nvim_get_current_buf()
  local newitem = {filename =  cfilename, lnum = cursorrow, col = cursorcol, text = cfilename, bufnr = bufnr }

  for k, v in pairs(quickfix_list) do
    -- Make sure we don't add duplicate elements on qf list 
    if v.col == cursorcol and v.lnum == cursorrow and v.bufnr == bufnr then
      return
    end
  end
  table.insert(quickfix_list, newitem)

  vim.fn.setqflist(quickfix_list)
end)

-- [[ text ]]  [[ text ]] [[ text ]]
vim.keymap.set("n", "<leader>qd",function ()
  local quickfix_list = vim.fn.getqflist()
  local newQuickFxList = {}
  local cursorrow = vim.api.nvim_win_get_cursor(0)[1]
  local cursorcol = vim.api.nvim_win_get_cursor(0)[2] + 1
  local bufnr = vim.api.nvim_get_current_buf()
  for k, v in pairs(quickfix_list) do
    -- Make sure we don't add duplicate elements on qf list 
    if not (v.col == cursorcol and v.lnum == cursorrow and v.bufnr == bufnr) then
      table.insert(newQuickFxList, v)
    end
  end

  vim.fn.setqflist(newQuickFxList)
end)

vim.keymap.set("n", "<leader>qc",function ()
  local quickfix_list = vim.fn.getqflist()
  local bufnr = vim.api.nvim_get_current_buf()
  local index = 1;
  local targetIndex;
  for _, v in pairs(quickfix_list) do
    if v.bufnr == bufnr then
      targetIndex = index
    end
    index = index + 1
  end

  if targetIndex then
    vim.cmd("cc " .. targetIndex)
  end
end)

vim.keymap.set("n", "qc",function ()
  vim.cmd("cclose")
end)

vim.keymap.set("n", "qo",function ()
  vim.cmd("copen")
end)

-- center 
vim.api.nvim_create_augroup('CenterBuffer', { clear = true })
vim.api.nvim_create_autocmd('CursorMoved', {
  group = 'CenterBuffer',
  pattern = '*',
  command = 'normal! zz',
})
