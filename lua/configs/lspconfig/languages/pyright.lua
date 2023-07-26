local M = {}

M.pyright = function(capabilities, on_attach)
	local pyright = vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver"
	local lsp = require('lspconfig')
	local setup = {
		cmd = { pyright, "--stdio" },
		on_attach = on_attach,
	}
	return setup
end

return M
