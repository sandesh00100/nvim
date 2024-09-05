function string:endswith(suffix)
	-- # referes to the length of the suffix
	return self:sub(-#suffix) == suffix
end

vim.keymap.set("n", "<leader>tl", "<cmd>:Telescope<cr>")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function ()
	builtin.find_files({wrap_results=true})
end)
vim.keymap.set('n', '<leader>pg', builtin.live_grep)
-- Git file search, where you only find files in your git repo
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- Grep string, probably will be faster 
vim.keymap.set('n', '<leader>ps',function() 
	builtin.grep_string({search = vim.fn.input("Grep > ")})
end)

-- Get references
vim.keymap.set('n', 'gr',function() 
	builtin.lsp_references({preview=true})
end)
-- Get references
vim.keymap.set('n', '<leader>gr', function () builtin.lsp_references({initial_mode="normal"}) end)
-- Get implementations
vim.keymap.set('n', 'gi',function() 
	builtin.lsp_implementations()
end)

-- Hierarchy incoming
vim.keymap.set('n', '<leader>hi',function() 
	builtin.lsp_incoming_calls({initial_mode="normal", show_line=true, wrap_results=true, truncate=3})
end)

-- Hierarchy outgoing
vim.keymap.set('n', '<leader>ho',function() 
	builtin.lsp_outgoing_calls({initial_mode="normal", show_line=true, wrap_results=true, truncate=3})
end)

-- Method tree
vim.keymap.set('n', '<leader>mt',function() 
	local fileName = vim.fn.expand("%")
	if fileName:endswith(".java") or fileName:endswith(".class") then
		builtin.treesitter({default_text=":method:"})
	else 
		builtin.treesitter({default_text=":function:"})
	end
end)

vim.keymap.set('n', '<leader>ct',function() 
  builtin.treesitter({default_text=":type:"})
end)

-- File tree
vim.keymap.set('n', '<leader>ft',function() 
	builtin.treesitter()
end)

-- Diagnostics Open
vim.keymap.set('n', '<leader>do',function() 
	builtin.diagnostics()
end)
-- Diagnostics Error
vim.keymap.set('n', '<leader>de',function() 
	builtin.diagnostics({default_text=":E:", initial_mode="normal", wrap_results=true, truncate=3})
end)
-- Diagnostics Warn
vim.keymap.set('n', '<leader>dw',function() 
	builtin.diagnostics({default_text=":W:", initial_mode="normal", wrap_results=true})
end)
-- Diagnostics Info
vim.keymap.set('n', '<leader>di',function() 
	builtin.diagnostics({default_text=":I:", initial_mode="normal", wrap_results=true})
end)
-- Diagnostics Info
vim.keymap.set('n', '<leader>di',function() 
	builtin.diagnostics({default_text=":I:", initial_mode="normal", wrap_results=true})
end)

-- Diagnostics Next
vim.keymap.set('n', '<leader>dn',function() 
	vim.diagnostic.goto_next();
end)

-- Diagnostics Previous
vim.keymap.set('n', '<leader>dp',function() 
	vim.diagnostic.goto_prev();
end)
--

vim.keymap.set('n', '<leader>gb',function() 
	builtin.git_branches();
end, {desc="View Branches"})

vim.keymap.set('n', '<leader>vk',function() 
	builtin.keymaps();
end, {desc="View Keymaps"})

vim.keymap.set('n', '<leader>ht',function() 
	builtin.help_tags();
end, {desc="Help Tags"})

-- vim.keymap.set('n', '<leader>fs', function() -- grep file contents in current nvim-tree node
--   local success, node = pcall(function() return require('nvim-tree.lib').get_node_at_cursor() end)
--   if not success or not node then return end;
--   require('telescope.builtin').live_grep({search_dirs = {node.absolute_path}})
-- end, {desc="Search current dir "})


vim.keymap.set('n', '<leader>tf', function() -- grep file contents in current nvim-tree node
  local success, node = pcall(function() return require('nvim-tree.lib').get_node_at_cursor() end)
  if not success or not node then return end;
  local absolute_path = node.absolute_path
  local searchPath
  if (node.has_children) then
    searchPath = absolute_path
  else
    local lastSeparator = absolute_path:find("[^/]*$")
    searchPath = absolute_path:sub(1, lastSeparator - 1)
  end
  require('telescope.builtin').find_files({search_dirs = {searchPath}})
end,{
  desc = "Telescope search on the directory in the nvim tree"
})


vim.keymap.set('n', '<leader>df', function() 
  local dir = vim.fn.expand("%:p:h")
  require('telescope.builtin').find_files({search_dirs = {dir}})
end,{
  desc = "Telescope search on directory of the current file"
})

vim.keymap.set('n', '<leader>cm', function ()
  require('telescope.builtin').commands();
end)

vim.keymap.set('n', '<leader>sw', function ()
  require('telescope.builtin').current_buffer_fuzzy_find();
end)

vim.keymap.set('n', '<leader>sp', function ()
  require('telescope.builtin').spell_suggest();
end)

vim.keymap.set('n', '<leader>ts', function ()
  require('telescope.builtin').git_status();
end, {desc="Telescope git status"})

vim.keymap.set('n', '<leader>gl', function ()
  require('telescope.builtin').git_commits();
end, { noremap = true, desc="View Git logs"})

vim.keymap.set('n', '<leader>gfl', function ()
  require('telescope.builtin').git_bcommits();
end, { noremap = true, desc="View Git file logs"})

vim.keymap.set('n', '<leader>lf', function()
  local dir = vim.fn.expand('%:h')
  require('telescope.builtin').find_files({find_command={"find",dir,"-maxdepth","1","-type","f"}})
end,{
  desc = "Telescope search on directory of the current file, non recursively"
})

vim.keymap.set('n', '<leader>ef', function()
  -- Ignore build, bin, and sort by the file types that have the most amount of files
  local handle = io.popen("find . -type f ! -path 'build' ! -path 'bin' ! -path 'rebased' ! -path '\\.git' | awk -F '.' '{print $NF}' | rg -v '/' | sort | uniq -c | sort -nr | awk '{print $NF}' ")
  local result = handle:read("*a")
  handle:close()

  -- Split string
  local fileTypes = {}
  for line in result.gmatch(result, "([^\n]+)") do
    table.insert(fileTypes, line)
  end

  -- Prompt for file type
  vim.ui.select(fileTypes, {
    prompt = "File Type",
    telescope = require("telescope.themes").get_dropdown(),
  },
  function (fileType)
    -- Telescope display
    require('telescope.builtin').find_files({find_command={"find",".","-name","*." .. fileType,"-type","f"}})
  end
  )
end,{
  desc = "Finds a particular file type after prompting"
})
