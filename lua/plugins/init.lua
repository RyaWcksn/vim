-- This file can be loaded by calling `lua require('plugins')` from your init.vimplinonplini
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
	-- { 'rcarriga/nvim-notify' },
	{
		"williamboman/mason.nvim",
		lazy = true,
		config = function()
			require('configs.mason')
		end,
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
	},

	{
		"mfussenegger/nvim-jdtls",
		ft = "java"
	},
	{
		"simrat39/rust-tools.nvim",
		ft = " rust"
	},
	{
		"saecki/crates.nvim",
		config = function()
			require('configs.crates')
		end,
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require('configs.comment')
		end,
	},

	{
		"APZelos/blamer.nvim"
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
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
		cmd = { "LspInstall", "LspUninstall" },
		dependencies = "mason.nvim",
	},
	{
		'scalameta/nvim-metals',
		config = function()
			require('configs.metals')
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- Lsp
	{
		'neovim/nvim-lspconfig',
		lazy = true,
		config = function()
			require('configs.lspconfig')
		end,
	},

	-- Flutter
	{
		"akinsho/flutter-tools.nvim",
		ft = "dart",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("configs.flutter")
		end,
	},

	{
		"folke/which-key.nvim",
		config = function()
			require('configs.whichkey')
		end,
		cmd = "WhichKey",
		event = "VeryLazy",
	},
	{
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('configs.treesitter')
		end,
		cmd = {
			"TSInstall",
			"TSUninstall",
			"TSUpdate",
			"TSUpdateSync",
			"TSInstallInfo",
			"TSInstallSync",
			"TSInstallFromGrammar",
		},
		event = "User FileOpened",
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = false,
	},
	{ 'nvim-treesitter/playground' },

	{
		'nvim-tree/nvim-tree.lua',
		dependencies = 'nvim-tree/nvim-web-devicons',
		cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
		config = function()
			require('configs/nvim-tree')
		end,
		event = "User DirOpened",
	},

	-- Telescope
	{ 'nvim-lua/plenary.nvim' },
	{
		'nvim-telescope/telescope.nvim',
		config = function()
			require('configs.telescope')
		end,
		lazy = true,
		cmd = "Telescope",
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', make = 'make' },

	{
		'hrsh7th/nvim-cmp',
		config = function()
			require('configs.cmp')
		end,
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"cmp-nvim-lsp",
			"cmp_luasnip",
			"cmp-buffer",
			"cmp-path",
		},
	},
	{ "hrsh7th/cmp-nvim-lsp",                     lazy = true },
	{ "saadparwaiz1/cmp_luasnip",                 lazy = true },
	{ "hrsh7th/cmp-buffer",                       lazy = true },
	{ "hrsh7th/cmp-path",                         lazy = true },
	{ "rafamadriz/friendly-snippets",             lazy = true },
	{
		'L3MON4D3/LuaSnip',
		config = function()
			require('configs.snippet')
		end,
		event = "InsertEnter",
		dependencies = {
			"friendly-snippets",
		},
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
	{
		'leoluz/nvim-dap-go',
		ft = "go"
	},

	{
		"olexsmir/gopher.nvim",
		dependencies = { -- dependencies
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("configs.gopher")
		end,
		ft = "go"
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
