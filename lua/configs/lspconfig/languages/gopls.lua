local M = {}

M.gopls = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
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
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		},
		codeLens = { enabled = true },
	}

	return setup
end

return M
