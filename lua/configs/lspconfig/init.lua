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



-- inlay_hin0

local on_attach = function(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
			callback = function() vim.lsp.buf.inlay_hint(0, true) end,
		})
		vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
			callback = function() vim.lsp.buf.inlay_hint(0, false) end,
		})
	end
end


-- Go LSP configuration
lsp.gopls.setup {
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


lsp.golangci_lint_ls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
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
	on_attach = on_attach,
	codeLens = { enabled = true },
	settings = { Lua = { hint = { enable = true } } }
}

-- typescript / Javascript
lsp.tsserver.setup {
	capabilities = capabilities,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascriptreact", "javascript" },
	cmd = { "typescript-language-server", "--stdio" },
	on_attach = on_attach,
	settings = {
		javascript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			},
		},
		typescript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			},
		},
	}
}

-- pyright
local pyright = vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver"
lsp.pyright.setup {
	cmd = { pyright, "--stdio" },
	on_attach = on_attach,
}

-- Tailwind
lsp.tailwindcss.setup {
	on_attach = on_attach,
}

-- PHP
lsp.intelephense.setup({
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	on_attach = on_attach,
	root_dir = lsp.util.root_pattern("composer.json", ".git")
})

lsp.phpactor.setup {}
lsp.cssls.setup {}
lsp.html.setup {}
lsp.bashls.setup {}

-- Dart
-- lsp.dartls.setup {}

-- Mysql
lsp.sqlls.setup {
	cmd = { "typescript-language-server", "--stdio" }
}
