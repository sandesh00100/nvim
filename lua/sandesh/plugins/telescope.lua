return {
		'nvim-telescope/telescope.nvim', version = '0.1.2',
		-- or                            , branch = '0.1.x',
		dependencies = {'nvim-lua/plenary.nvim'},
    config = function ()
      require('telescope').setup({
        defaults = {
          path_display = {
            "smart"
          }
        }
      })
    end
}
