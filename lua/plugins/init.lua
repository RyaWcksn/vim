-- This file can be loaded by calling `lua require('plugins')` from your init.vimplinon
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
		end,
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
	},

	{
		"mfussenegger/nvim-jdtls",
		ft = "java"
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
		cmd = { "LspInstall", "LspUninstall" },
		dependencies = "mason.nvim",
	},
	-- Lsp
	{
		'neovim/nvim-lspconfig',
		config = function()
			require('configs.lspconfig')
		end,
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
		end,
		cmd = "WhichKey",
		event = "VeryLazy",
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

	-- You can alias plugin names
	{ 'dracula/vim',               as = 'dracula' },
	{
		'nvim-tree/nvim-tree.lua',
		dependencies = 'nvim-tree/nvim-web-devicons',
		cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
		config = function()
			require('configs/nvim-tree')
		end,
		event = "User DirOpened",
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
		config = function()
			require('configs.lualine')
		end,
		event = "VimEnter",
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
	{ 'nvim-telescope/telescope-media-files.nvim' },
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
	{ "hrsh7th/cmp-nvim-lsp",         lazy = true },
	{ "saadparwaiz1/cmp_luasnip",     lazy = true },
	{ "hrsh7th/cmp-buffer",           lazy = true },
	{ "hrsh7th/cmp-path",             lazy = true },
	{ "rafamadriz/friendly-snippets", lazy = true },
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
