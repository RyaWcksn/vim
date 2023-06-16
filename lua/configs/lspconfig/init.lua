local lsp = require('lspconfig')
local codelens = require('vim.lsp.codelens')

vim.api.nvim_set_hl(0, 'LspCodeLens', { link = 'WarningMsg', default = true })
vim.api.nvim_set_hl(0, 'LspCodeLensText', { link = 'WarningMsg', default = true })
vim.api.nvim_set_hl(0, 'LspCodeLensSign', { link = 'WarningMsg', default = true })
vim.api.nvim_set_hl(0, 'LspCodeLensSeparator', { link = 'Boolean', default = true })

vim.o.updatetime = 250
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

vim.lsp.set_log_level("debug")

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


local config = {
	virtual_text = true,
	signs = {
		active = signs,
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}
vim.diagnostic.config(config)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	    virtual_text = true,
	    update_in_insert = false,
    })

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


lsp.golangci_lint_ls.setup {
	capabilities = capabilities,
	default_config = {
		cmd = { 'golangci-lint-langserver' },
		root_dir = lsp.util.root_pattern('.golangci.yml', '.golangci.yaml', '.golangci.toml', '.golangci.json',
			'go.work', 'go.mod', '.git'),
		init_options = {
			command = { "golangci-lint", "run", "--out-format", "json" },
		}
	},
	filetypes = { 'go', 'gomod' }

}

-- Lua
lsp.lua_ls.setup {
	capabilities = capabilities,
	codeLens = { enabled = true },
}

-- typescript / Javascript
lsp.tsserver.setup {
	capabilities = capabilities,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascriptreact", "javascript" },
	cmd = { "typescript-language-server", "--stdio" }
}

-- pyright
lsp.pyright.setup {}

-- Tailwind
lsp.tailwindcss.setup {}



-- Dart
-- lsp.dartls.setup {}

-- Mysql
lsp.sqlls.setup {
	cmd = { "typescript-language-server", "--stdio" }
}
