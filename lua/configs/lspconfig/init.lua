local lsp = require('lspconfig')
local notify = require 'notify'

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

local on_references = vim.lsp.handlers["textDocument/references"]
vim.lsp.handlers["textDocument/references"] = vim.lsp.with(on_references, { loclist = true, virtual_text = true })

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
	vim.lsp.handlers.signature_help, {
		border = 'rounded',
		close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
	}
)

local capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	local lvl = ({
		'ERROR',
		'WARN',
		'INFO',
		'DEBUG',
	})[result.type]
	notify({ result.message }, lvl, {
		title = 'LSP | ' .. client.name,
		timeout = 10000,
		keep = function()
			return lvl == 'ERROR' or lvl == 'WARN'
		end,
	})
end


capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}
capabilities.experimental = {}
capabilities.experimental.hoverActions = true

local on_attach = function(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.buf.inlay_hint(bufnr, true)
	end
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
				hi LspReferenceRead cterm=bold ctermbg=red guibg=#282f45
				hi LspReferenceText cterm=bold ctermbg=red guibg=#282f45
				hi LspReferenceWrite cterm=bold ctermbg=red guibg=#282f45
				augroup lsp_document_highlight
				autocmd! * <buffer>
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
				augroup END
			]],
			false
		)
	end
end

local servers = {
	gopls = require('configs.lspconfig.languages.gopls').gopls(capabilities, on_attach),
	golangci_lint_ls = require('configs.lspconfig.languages.golang-ci').golangci(capabilities, on_attach),
	pyright = require('configs.lspconfig.languages.pyright').pyright(capabilities, on_attach),
	rust_analyzer = require('configs.lspconfig.languages.rust-analyzer').rustanalyzer(capabilities, on_attach),
	tsserver = require('configs.lspconfig.languages.tsserver').tsserver(capabilities, on_attach),
	tailwindcss = require('configs.lspconfig.languages.tailwindcss').tailwind(capabilities, on_attach),
	lua_ls = require('configs.lspconfig.languages.lua-ls').lua_ls(capabilities, on_attach),
}

for server, cfg in pairs(servers) do
	lsp[server].setup( cfg )
end

