local lsp = require('lspconfig')

local protocol = require('vim.lsp.protocol')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Go LSP configuration
lsp.gopls.setup{}

-- Lua
lsp.sumneko_lua.setup{
    capabilities = capabilities
}
