
-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.2',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use ({'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'}})
	-- Abstract syntax tree
	use('nvim-treesitter/playground')
	-- Good for file nav, switching back and forth for files
	use('theprimeagen/harpoon')
	-- Lets you see a decision tree of undos and different branches
	use('mbbill/undotree')
	-- Vim git plugin 
	use('tpope/vim-fugitive')
	-- Lsp config
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{'williamboman/mason.nvim'},           -- Optional
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},     -- Required
			{'hrsh7th/cmp-nvim-lsp'}, -- Required
			{'L3MON4D3/LuaSnip'},     -- Required
		}
	}
	use({
		"epwalsh/obsidian.nvim",
		requires = {
			-- Required.
			"nvim-lua/plenary.nvim",
			-- see below for full list of optional dependencies 👇
		},
		config = function()
			require("obsidian").setup({
				dir = "~/Documents/Dropbox/Notes",
				-- see below for full list of options 👇
			})
		end,
	})
	-- Gruv box theme
	use { "ellisonleao/gruvbox.nvim" }
	-- Java LSP
	use { 'mfussenegger/nvim-jdtls'	 }
end)

