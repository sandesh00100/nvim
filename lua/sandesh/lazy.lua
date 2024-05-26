local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	 {
		'nvim-telescope/telescope.nvim', version = '0.1.2',
		-- or                            , branch = '0.1.x',
		dependencies = { {'nvim-lua/plenary.nvim'} }
	},
	{'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
	-- Abstract syntax tree
	'nvim-treesitter/playground',
	-- Good for file nav, switching back and forth for files
	'theprimeagen/harpoon',
	-- Lets you see a decision tree of undos and different branches
	'mbbill/undotree',
	-- Vim git plugin 
	'tpope/vim-fugitive',
	-- Lsp config
	{
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
		}
	},
-- Gruv box theme
	{ "ellisonleao/gruvbox.nvim" },
	-- Java lsp
	{'mfussenegger/nvim-jdtls'},
	-- Debugging
	{'mfussenegger/nvim-dap'},
	-- use {'rcarriga/cmp-dap'}
	
	{'nvim-tree/nvim-web-devicons'},
  {
		"neanias/everforest-nvim",
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			require("everforest").setup()
		end,
	},
	{"LunarVim/bigfile.nvim"},
	{'nvim-lualine/lualine.nvim', 
		dependencies = {'nvim-tree/nvim-web-devicons', opt = true}
	},
	-- Auto pair characters like '{' or '"' etc
	{
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	},
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},

	{ 
		'rcarriga/nvim-dap-ui', dependencies = {'mfussenegger/nvim-dap'}
	},
	{ 
		'lewis6991/gitsigns.nvim'
	},
	-- ChatGPT
  {
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
	-- Surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
	'nvim-tree/nvim-web-devicons',
	-- Tree view for files
	{"nvim-tree/nvim-tree.lua"},
	-- Rest client
	{"diepm/vim-rest-console"},

  {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
  },
	{'xiyaowong/transparent.nvim'},
  {'bullets-vim/bullets.vim'},
  {'Pocco81/auto-save.nvim'},
  {'hrsh7th/nvim-cmp', dependencies={
    -- Snippet engine & associated nvim-cmp source
    -- https://github.com/L3MON4D3/LuaSnip
    'L3MON4D3/LuaSnip',
    -- https://github.com/saadparwaiz1/cmp_luasnip
    'saadparwaiz1/cmp_luasnip',

    -- LSP completion capabilities
    -- https://github.com/hrsh7th/cmp-nvim-lsp
    'hrsh7th/cmp-nvim-lsp',

    -- Additional user-friendly snippets
    -- https://github.com/rafamadriz/friendly-snippets
    'rafamadriz/friendly-snippets',
    -- https://github.com/hrsh7th/cmp-buffer
    'hrsh7th/cmp-buffer',
    -- https://github.com/hrsh7th/cmp-path
    'hrsh7th/cmp-path',
    -- https://github.com/hrsh7th/cmp-cmdline
    'hrsh7th/cmp-cmdline',
  }},
  {"m4xshen/hardtime.nvim", 
  require={
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim"
  }
},
}
require("lazy").setup(plugins, opts)

