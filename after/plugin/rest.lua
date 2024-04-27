vim.g.vrc_set_default_mapping = 0
vim.g.vrc_auto_format_response_patterns = {
	json = 'jq'
}
vim.keymap.set("n","<leader>xr", ":call VrcQuery()<CR>")
