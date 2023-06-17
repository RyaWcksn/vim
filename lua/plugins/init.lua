-- This file can be loaded by calling `lua require('plugins')` from your init.vim
--
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
	{
		"williamboman/mason.nvim",
		config = function()
			require('configs.mason')
		end
	},

	-- RPC
	{
		'andweeb/presence.nvim',
		config = function()
			require('configs.presence')
		end
	},

	-- Database
	{ 'tpope/vim-dadbod' },
	{ 'kristijanhusak/vim-dadbod-ui' },

	{
		"williamboman/mason-lspconfig.nvim"
	},
	-- Lsp
	{
		'neovim/nvim-lspconfig',
		config = function()
			require('configs.lspconfig')
		end
	},

	-- Flutter
	--
	{
		"akinsho/flutter-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("configs.flutter")
		end,
	},
	--  {
	-- 	"jesseleite/nvim-noirbuddy",
	-- 	dependencies = { "tjdevries/colorbuddy.nvim", branch = "dev" },,
	-- 	config = function()
	-- 		require('configs.noirbuddy')
	-- 	end
	-- },
	{ 'nyoom-engineering/oxocarbon.nvim' },


	{
		"folke/which-key.nvim",
		config = function()
			require('configs.whichkey')
		end
	},
	-- Lazy loading:
	-- Load on specific commands
	{ 'tpope/vim-dispatch',              opt = true, cmd = { 'Dispatch', 'Make', 'Focus', 'Start' }, },

	-- Post-install/update hook with neovim command
	{
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('configs.treesitter')
		end
	},
	{ 'nvim-treesitter/playground' },

	-- You can alias plugin names
	{ 'dracula/vim',               as = 'dracula' },
	{
		'nvim-tree/nvim-tree.lua',
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			require('configs/nvim-tree')
		end
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
		config = function()
			require('configs.lualine')
		end
	},
	-- Telescope
	{ 'nvim-lua/plenary.nvim' },
	{
		'nvim-telescope/telescope.nvim',
		config = function()
			require('configs.telescope')
		end
	},
	{ 'nvim-telescope/telescope-media-files.nvim' },
	{ 'nvim-telescope/telescope-fzf-native.nvim', make = 'make' },

	{
		'hrsh7th/nvim-cmp',
		config = function()
			require('configs.cmp')
		end
	},
	{
		'hrsh7th/cmp-nvim-lsp'
	},
	{
		'saadparwaiz1/cmp_luasnip'
	},
	{ "rafamadriz/friendly-snippets" },
	{
		'L3MON4D3/LuaSnip',
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require('configs.snippet')
		end
	},

	{
		'TimUntersberger/neogit',
		dependencies = 'nvim-lua/plenary.nvim',
		config = function()
			require('configs.neogit')
		end
	},
	{
		'akinsho/bufferline.nvim',
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			require('configs.bufferline')
		end
	},
	{
		"klen/nvim-test",
		config = function()
			require('configs.test')
		end
	},

	-- Debugging
	{
		'mfussenegger/nvim-dap'
	},
	{
		"rcarriga/nvim-dap-ui",
		config = function()
			require("configs.dap")
		end
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		config = function()
			require("configs.mason-dap")
		end
	},
	{ 'leoluz/nvim-dap-go' },

	{
		"olexsmir/gopher.nvim",
		dependencies = { -- dependencies
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("configs.gopher")
		end
	},
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("configs.toggleterm")
		end
	},

	{
		"windwp/nvim-autopairs",
		wants = "nvim-treesitter",
		module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
		config = function()
			require("configs.autopairs")
		end,
	},
})

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
-- 
-- return require('packer').startup(function(use)
-- 	-- Packer can manage itself
-- 	use 'wbthomason/packer.nvim'
-- 	use {
-- 		"williamboman/mason.nvim",
-- 		config = function()
-- 			require('configs.mason')
-- 		end
-- 	}
-- 
-- 	-- RPC
-- 	use {
-- 		'andweeb/presence.nvim',
-- 		config = function()
-- 			require('configs.presence')
-- 		end
-- 	}
-- 
-- 	-- Database
-- 	use { 'tpope/vim-dadbod' }
-- 	use { 'kristijanhusak/vim-dadbod-ui' }
-- 
-- 	use {
-- 		"williamboman/mason-lspconfig.nvim"
-- 	}
-- 	-- Lsp
-- 	use {
-- 		'neovim/nvim-lspconfig',
-- 		config = function()
-- 			require('configs.lspconfig')
-- 		end
-- 	}
-- 
-- 	-- Flutter
-- 	--
-- 	use {
-- 		"akinsho/flutter-tools.nvim",
-- 		requires = { "nvim-lua/plenary.nvim" },
-- 		config = function()
-- 			require("configs.flutter")
-- 		end,
-- 	}
-- 	-- use {
-- 	-- 	"jesseleite/nvim-noirbuddy",
-- 	-- 	requires = { "tjdevries/colorbuddy.nvim", branch = "dev" },
-- 	-- 	config = function()
-- 	-- 		require('configs.noirbuddy')
-- 	-- 	end
-- 	-- }
-- 	use { 'nyoom-engineering/oxocarbon.nvim' }
-- 
-- 
-- 	use {
-- 		"folke/which-key.nvim",
-- 		config = function()
-- 			require('configs.whichkey')
-- 		end
-- 	}
-- 	-- Lazy loading:
-- 	-- Load on specific commands
-- 	use { 'tpope/vim-dispatch', opt = true, cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }
-- 
-- 	-- Post-install/update hook with neovim command
-- 	use {
-- 		'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
-- 		config = function()
-- 			require('configs.treesitter')
-- 		end
-- 	}
-- 	use { 'nvim-treesitter/playground' }
-- 
-- 	-- You can alias plugin names
-- 	use { 'dracula/vim', as = 'dracula' }
-- 	use {
-- 		'nvim-tree/nvim-tree.lua',
-- 		requires = 'nvim-tree/nvim-web-devicons',
-- 		config = function()
-- 			require('configs/nvim-tree')
-- 		end
-- 	}
-- 	use {
-- 		'nvim-lualine/lualine.nvim',
-- 		requires = { 'nvim-tree/nvim-web-devicons', opt = true },
-- 		config = function()
-- 			require('configs.lualine')
-- 		end
-- 	}
-- 	-- Telescope
-- 	use { 'nvim-lua/plenary.nvim' }
-- 	use {
-- 		'nvim-telescope/telescope.nvim',
-- 		config = function()
-- 			require('configs.telescope')
-- 		end
-- 	}
-- 	use { 'nvim-telescope/telescope-media-files.nvim' }
-- 	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
-- 
-- 	use {
-- 		'hrsh7th/nvim-cmp',
-- 		config = function()
-- 			require('configs.cmp')
-- 		end
-- 	}
-- 	use {
-- 		'hrsh7th/cmp-nvim-lsp'
-- 	}
-- 	use {
-- 		'saadparwaiz1/cmp_luasnip'
-- 	}
-- 	use { "rafamadriz/friendly-snippets" }
-- 	use {
-- 		'L3MON4D3/LuaSnip',
-- 		dependencies = { "rafamadriz/friendly-snippets" },
-- 		config = function()
-- 			require('configs.snippet')
-- 		end
-- 	}
-- 
-- 	use {
-- 		'TimUntersberger/neogit',
-- 		requires = 'nvim-lua/plenary.nvim',
-- 		config = function()
-- 			require('configs.neogit')
-- 		end
-- 	}
-- 	use {
-- 		'akinsho/bufferline.nvim',
-- 		tag = "*",
-- 		requires = 'nvim-tree/nvim-web-devicons',
-- 		config = function()
-- 			require('configs.bufferline')
-- 		end
-- 	}
-- 	use {
-- 		"klen/nvim-test",
-- 		config = function()
-- 			require('configs.test')
-- 		end
-- 	}
-- 
-- 	-- Debugging
-- 	use {
-- 		'mfussenegger/nvim-dap'
-- 	}
-- 	use {
-- 		"rcarriga/nvim-dap-ui",
-- 		config = function()
-- 			require("configs.dap")
-- 		end
-- 	}
-- 	use {
-- 		"jay-babu/mason-nvim-dap.nvim",
-- 		config = function()
-- 			require("configs.mason-dap")
-- 		end
-- 	}
-- 	use { 'leoluz/nvim-dap-go' }
-- 
-- 	use {
-- 		"olexsmir/gopher.nvim",
-- 		requires = { -- dependencies
-- 			"nvim-lua/plenary.nvim",
-- 			"nvim-treesitter/nvim-treesitter",
-- 		},
-- 		config = function()
-- 			require("configs.gopher")
-- 		end
-- 	}
-- 	use { "akinsho/toggleterm.nvim", tag = '*', config = function()
-- 		require("configs.toggleterm")
-- 	end }
-- 
-- 	use {
-- 		"windwp/nvim-autopairs",
-- 		wants = "nvim-treesitter",
-- 		module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
-- 		config = function()
-- 			require("configs.autopairs")
-- 		end,
-- 	}
-- end)
