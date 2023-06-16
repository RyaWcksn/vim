-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
	use {
		"williamboman/mason.nvim",
		config = function()
			require('configs.mason')
		end
	}

	-- RPC
	use {
		'andweeb/presence.nvim',
		config = function ()
			require('configs.presence')
		end
	}

	-- Database
	use { 'tpope/vim-dadbod' }
	use { 'kristijanhusak/vim-dadbod-ui' }

	use {
		"williamboman/mason-lspconfig.nvim"
	}
	-- Lsp
	use {
		'neovim/nvim-lspconfig',
		config = function()
			require('configs.lspconfig')
		end
	}

	-- Flutter
	--
	use {
		"akinsho/flutter-tools.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("configs.flutter")
		end,
	}
	-- use {
	-- 	"jesseleite/nvim-noirbuddy",
	-- 	requires = { "tjdevries/colorbuddy.nvim", branch = "dev" },
	-- 	config = function()
	-- 		require('configs.noirbuddy')
	-- 	end
	-- }
	use { 'nyoom-engineering/oxocarbon.nvim' }


	use {
		"folke/which-key.nvim",
		config = function()
			require('configs.whichkey')
		end
	}
	-- Lazy loading:
	-- Load on specific commands
	use { 'tpope/vim-dispatch', opt = true, cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }

	-- Post-install/update hook with neovim command
	use {
		'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
		config = function()
			require('configs.treesitter')
		end
	}
	use { 'nvim-treesitter/playground' }

	-- You can alias plugin names
	use { 'dracula/vim', as = 'dracula' }
	use {
		'nvim-tree/nvim-tree.lua',
		requires = 'nvim-tree/nvim-web-devicons',
		config = function()
			require('configs/nvim-tree')
		end
	}
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true },
		config = function()
			require('configs.lualine')
		end
	}
	-- Telescope
	use { 'nvim-lua/plenary.nvim' }
	use {
		'nvim-telescope/telescope.nvim',
		config = function()
			require('configs.telescope')
		end
	}
	use { 'nvim-telescope/telescope-media-files.nvim' }
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

	use {
		'hrsh7th/nvim-cmp',
		config = function()
			require('configs.cmp')
		end
	}
	use {
		'hrsh7th/cmp-nvim-lsp'
	}
	use {
		'saadparwaiz1/cmp_luasnip'
	}
	use { "rafamadriz/friendly-snippets" }
	use {
		'L3MON4D3/LuaSnip',
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require('configs.snippet')
		end
	}

	use {
		'TimUntersberger/neogit',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('configs.neogit')
		end
	}
	use {
		'akinsho/bufferline.nvim',
		tag = "*",
		requires = 'nvim-tree/nvim-web-devicons',
		config = function()
			require('configs.bufferline')
		end
	}
	use {
		"klen/nvim-test",
		config = function()
			require('configs.test')
		end
	}

	-- Debugging
	use {
		'mfussenegger/nvim-dap'
	}
	use {
		"rcarriga/nvim-dap-ui",
		config = function()
			require("configs.dap")
		end
	}
	use {
		"jay-babu/mason-nvim-dap.nvim",
		config = function()
			require("configs.mason-dap")
		end
	}
	use { 'leoluz/nvim-dap-go' }

	use {
		"olexsmir/gopher.nvim",
		requires = { -- dependencies
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("configs.gopher")
		end
	}
	use { "akinsho/toggleterm.nvim", tag = '*', config = function()
		require("configs.toggleterm")
	end }

	use {
		"windwp/nvim-autopairs",
		wants = "nvim-treesitter",
		module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
		config = function()
			require("configs.autopairs")
		end,
	}
end)
