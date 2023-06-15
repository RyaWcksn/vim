local wk = require("which-key")

wk.setup {
	{
		plugins = {
			marks = true, -- shows a list of your marks on ' and `
			registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
			-- the presets plugin, adds help for a bunch of default keybindings in Neovim
			-- No actual key bindings are created
			spelling = {
				enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
				suggestions = 20, -- how many suggestions should be shown in the list?
			},
			presets = {
				operators = true, -- adds help for operators like d, y, ...
				motions = true, -- adds help for motions
				text_objects = true, -- help for text objects triggered after entering an operator
				windows = true, -- default bindings on <c-w>
				nav = true, -- misc bindings to work with windows
				z = true, -- bindings for folds, spelling and others prefixed with z
				g = true, -- bindings for prefixed with g
			},
		},
		-- add operators that will trigger motion and text object completion
		-- to enable all native operators, set the preset / operators plugin above
		operators = { gc = "Comments" },
		key_labels = {
			-- override the label used to display some keys. It doesn't effect WK in any other way.
			-- For example:
			-- ["<space>"] = "SPC",
			-- ["<cr>"] = "RET",
			-- ["<tab>"] = "TAB",
		},
		motions = {
			count = true,
		},
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		popup_mappings = {
			scroll_down = "<c-d>", -- binding to scroll down inside the popup
			scroll_up = "<c-u>", -- binding to scroll up inside the popup
		},
		window = {
			border = "none", -- none, single, double, shadow
			position = "bottom", -- bottom, top
			margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
			padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
			winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
			zindex = 1000, -- positive value to position WhichKey above other floating windows.
		},
		layout = {
			height = { min = 4, max = 25 },                             -- min and max height of the columns
			width = { min = 20, max = 50 },                             -- min and max width of the columns
			spacing = 3,                                                -- spacing between columns
			align = "left",                                             -- align columns left, center or right
		},
		ignore_missing = false,                                             -- enable this to hide mappings for which you didn't specify a label
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
		show_help = true,                                                   -- show a help message in the command line for using WhichKey
		show_keys = true,                                                   -- show the currently pressed key and its label as a message in the command line
		triggers = "auto",                                                  -- automatically setup triggers
		-- triggers = {"<leader>"} -- or specifiy a list manually
		-- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
		triggers_nowait = {
			-- marks
			"`",
			"'",
			"g`",
			"g'",
			-- registers
			'"',
			"<c-r>",
			-- spelling
			"z=",
		},
		triggers_blacklist = {
			-- list of mode / prefixes that should never be hooked by WhichKey
			-- this is mostly relevant for keymaps that start with a native binding
			i = { "j", "k" },
			v = { "j", "k" },
		},
		-- disable the WhichKey popup for certain buf types and file types.
		-- Disabled by default for Telescope
		disable = {
			buftypes = {},
			filetypes = {},
		},
	}
}

wk.register({
	w = {
		name = "+Window",
		k = { "<c-w>k", "Switch Up" },
		j = { "<c-w>j", "Switch Down" },
		h = { "<c-w>h", "Switch Leff" },
		l = { "<c-w>l", "Switch Right" },
		K = { ":res +5<CR>", "Resize Up" },
		J = { ":res -5<CR>", "Resize Down" },
		H = { ":vertical res -5<CR>", "Resize Left" },
		L = { ":vertical res +5<CR>", "Resize Right" },
		q = { ":q!<CR>", "Kill Window" },
		["<Leader>"] = {
			name = "+Split",
			k = { ":vs<CR>", "Split Vertically" },
			j = { ":sp<CR>", "Split Horizontally" },
		},
	},
	f = {
		name = "+Finds",
		f = { ":Telescope find_files theme=dropdown<CR>", "Find Files" },
		w = { ":Telescope live_grep<CR>", "Find Words" },
		g = { ":Telescope git_status<CR>", "Find Commits" },
		b = { ":lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({}))<CR>",
			"Find Buffers" },
		h = { ":Telescope help_tags<CR>", "Find Helps" },
	},
	p = {
		name = "+Packer",
		s = { ":PackerSync<CR>", "Sync plugins" },
		i = { ":PackerInstall<CR>", "Install plugins" }
	},
	s = {
		name = "+Save",
		w = { ":w<CR>", "Save" },
		s = { ":SudaWrite<CR>", "Sudo save" },
	},
	g = {
		name = "+Git",
		g = { ":Neogit<CR>", "Neogit" },
	},
	o = {
		name = "+Open",
		e = { ":NvimTreeToggle<CR>", "NvimTree" },
		t = { ":ToggleTerm<CR>", "ToggleTerm" },
	},
	l = {
		name = "+LSP",
		f = { ":lua vim.lsp.buf.format()<CR>", "Code Format" },
		c = { ":lua vim.lsp.buf.code_action()<CR>", "Code Action" },
		s = { ":lua vim.lsp.buf.signature_help()<CR>", "Code Signature" },
		d = { ":lua vim.lsp.buf.definition()<CR>", "Code Definition" },
		i = { ":lua vim.lsp.buf.implementation()<CR>", "Code Implementation" },
		w = { ":lua vim.lsp.buf.references()<CR>", "Code References" },
		l = { ":lua vim.lsp.codelens.run()<CR>", "Code Lens" },
		L = { ":lua vim.lsp.codelens.refresh()<CR>", "Code Lens" },
		r = { ":lua vim.lsp.buf.rename()<CR>", "Rename" },
		t = { ":Telescope diagnostics<CR>", "Error Diagnostics" },
		["["] = { ":lua vim.diagnostic.goto_prev()<CR>", "Prev Diagnostics" },
		["]"] = { ":lua vim.diagnostic.goto_next()<CR>", "Next Diagnostics" },
	},
	d = {
		name = "+DB",
		u = { ':DBUIToggle<CR>', 'Toggle DBUI' },
		f = { ':DBUIFindBuffer<CR>', 'Find Buffer in DBUI' },
		r = { ':DBUIRenameBuffer<CR>', 'Rename Buffer in DBUI' },
		l = { ':DBUILastQueryInfo<CR>', 'Show Last Query Info in DBUI' }
	},
	K = { ":lua vim.lsp.buf.hover()<CR>", "Hover" },
}, { prefix = "<leader>", mode = "n", noremap = true })

wk.register({
}, { prefix = "<leader>", mode = "n", noremap = true })
