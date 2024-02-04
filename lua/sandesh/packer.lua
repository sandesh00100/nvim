
-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- comment 
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
			-- All mason files are in ~/.local/share/nvim/mason/bin
			{'williamboman/mason.nvim'},           -- Optional
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},     -- Required
			{'hrsh7th/cmp-nvim-lsp'}, -- Required
			{'L3MON4D3/LuaSnip'},     -- Required
		}
	}
	-- Gruv box theme
	use { "ellisonleao/gruvbox.nvim" }
	-- Java lsp
	use {'mfussenegger/nvim-jdtls'}
	-- Debugging
	use {'mfussenegger/nvim-dap'}
	-- use {'rcarriga/cmp-dap'}
	use({
		"neanias/everforest-nvim",
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			require("everforest").setup()
		end,
	})
	-- Auto pair characters like '{' or '"' etc
	use {
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	}
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}
	use { 
		'lewis6991/gitsigns.nvim'
	}
end)

