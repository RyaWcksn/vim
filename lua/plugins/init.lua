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
	use {
		"jesseleite/nvim-noirbuddy",
		requires = { "tjdevries/colorbuddy.nvim", branch = "dev" },
		config = function()
			require('configs.noirbuddy')
		end
	}


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

	use { "mfussenegger/nvim-dap" }

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
	use {
		'L3MON4D3/LuaSnip'
	}

	use {
		'TimUntersberger/neogit',
		requires = 'nvim-lua/plenary.nvim',
		config = function ()
			require('configs.neogit')
		end
	}
end)
