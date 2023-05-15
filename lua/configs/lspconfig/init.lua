local lsp = require('lspconfig')

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
					unusedparams = true,
				},
				staticcheck = true,
			},
		},
	},
}

-- Lua
lsp.lua_ls.setup {
	capabilities = capabilities
}
