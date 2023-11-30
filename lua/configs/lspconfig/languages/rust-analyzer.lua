local M = {}

M.rustanalyzer = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_dir = lsp.util.root_pattern("Cargo.toml"),
		settings = {
			['rust-analyzer'] = {
				diagnostics = {
					enable = false,
				},
				cargo = {
					allFeatures = true,
				}
			}
		},
	}
	return setup
end

return M
