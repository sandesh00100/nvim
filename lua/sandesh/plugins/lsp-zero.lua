return {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		dependencies = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			-- All mason files are in ~/.local/share/nvim/mason/bin
			{'williamboman/mason.nvim'},           -- Optional
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},     -- Required
			{'hrsh7th/cmp-nvim-lsp'}, -- Required
			{'L3MON4D3/LuaSnip'},     -- Required
		},
    config = function ()
      local lsp = require('lsp-zero')

      lsp.preset('recommended')
      lsp.skip_server_setup({'jdtls'})
      lsp.setup()

    end
	}
