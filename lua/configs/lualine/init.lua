colors = {
    bg       = '#262626',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}


module = {
	lsp = {
		function()
			local msg = 'No Active Lsp'
			local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
			local clients = vim.lsp.get_active_clients()
			if next(clients) == nil then
				return msg
			end
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
					return client.name
				end
			end
			return msg
		end,
		icon = ' LSP:',
		color = { fg = '#ffffff', gui = 'bold' },
	},
	diff = {
		"diff",
		colored = false,
		symbols = { added = "  ", modified = " ", removed = " " },
		cond = hide_in_width,
		color = { fg = '#ffffff', bg = '#262626' },
	},
	diagnostic = {
		"diagnostics",
		sources = { "nvim_diagnostic", "nvim_lsp" },
		sections = { "error", "warn", "info", "hint" },
		diagnostics_color = {
			error = "DiagnosticError", -- Changes diagnostics' error color.
			warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
			info = "DiagnosticInfo", -- Changes diagnostics' info color.
			hint = "DiagnosticHint", -- Changes diagnostics' hint color.
		},
		symbols = { error = " ", warn = " ", info = " ", hint = " " },
		colored = true,  -- Displays diagnostics status in color if set to true.
		update_in_insert = true, -- Update diagnostics in insert mode.
		always_visible = false, -- Show diagnostics even if there are none.
		color = { fg = '#ffffff', bg = '#262626' },
	},
	branch = {
		"branch",
		cond = hide_in_width,
		icon = " ",
		color = { fg = '#ffffff', bg = '#262626' },
	},
	user = {
		function()
			local user = os.capture("git config --get user.name")
			return " " .. user
		end,
		color = { fg = '#ffffff', bg = '#262626' },
	},
	mode = {
		function()
			return ""
		end,
		color = function()
			local mode_color = {
				n = colors.magenta,
				i = colors.green,
				v = colors.blue,
				[''] = colors.blue,
				V = colors.blue,
				c = colors.magenta,
				no = colors.red,
				s = colors.orange,
				S = colors.orange,
				[''] = colors.orange,
				ic = colors.yellow,
				R = colors.violet,
				Rv = colors.violet,
				cv = colors.red,
				ce = colors.red,
				r = colors.cyan,
				rm = colors.cyan,
				['r?'] = colors.cyan,
				['!'] = colors.red,
				t = colors.red,
			}
			return { fg = mode_color[vim.fn.mode()], bg = colors.bg }
		end
	},
}


require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = module.lualine_theme,
		disabled_filetypes = { 'dashboard', 'NvimTree', 'Outline', 'Terminal' },
		section_separators = {
			left = "",
			right = "",
		},
		component_separators = {
			left = "",
			right = "",
		},
	},

	sections = {
		lualine_a = {},
		lualine_b = { module.mode, module.branch, module.lsp },
		lualine_c = {},
		lualine_x = {},
		lualine_y = { module.diagnostic, module.diff },
		lualine_z = {},

	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "hostname" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "nvim-tree" },
})
