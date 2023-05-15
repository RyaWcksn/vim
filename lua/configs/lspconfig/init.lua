local lsp = require('lspconfig')
local codelens = require('vim.lsp.codelens')
codelens.refresh()




vim.api.nvim_set_hl(0, 'LspCodeLens', { link = 'WarningMsg', default = true })
vim.api.nvim_set_hl(0, 'LspCodeLensText', { link = 'WarningMsg', default = true })
vim.api.nvim_set_hl(0, 'LspCodeLensSign', { link = 'WarningMsg', default = true })
vim.api.nvim_set_hl(0, 'LspCodeLensSeparator', { link = 'Boolean', default = true })

local protocol = require('vim.lsp.protocol')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Go LSP configuration
lsp.gopls.setup {
	capabilities = capabilities,
	default_config = {
		cmd = { 'gopls' },
		filetypes = { 'go' },
		root_dir = lsp.util.root_pattern('.git', 'go.mod', '.'),
		settings = {
			gopls = {
				analyses = {
					unreachable = true,
					nilness = true,
					unusedparams = true,
					useany = true,
					unusedwrite = true,
					ST1003 = true,
					undeclaredname = true,
					fillreturns = true,
					nonewvars = true,
					fieldalignment = false,
					shadow = true,
				},
				codelenses = {
					generate = true, -- show the `go generate` lens.
					gc_details = true, -- Show a code lens toggling the display of gc's choices.
					test = true,
					tidy = true,
					vendor = true,
					regenerate_cgo = true,
					upgrade_dependency = true,
				},
				staticcheck = true,
				usePlaceholders = true,
				completeUnimported = true,
				matcher = 'Fuzzy',
				diagnosticsDelay = '500ms',
				symbolMatcher = 'fuzzy',
				buildFlags = { '-tags', 'integration' },
			},
		},
	},
	codeLens = { enabled = true },
}

-- Lua
lsp.lua_ls.setup {
	capabilities = capabilities,
	codeLens = { enabled = true },
}
