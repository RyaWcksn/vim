local lsp = require('lspconfig')
local notify = require 'notify'
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}
capabilities.experimental = {}
capabilities.experimental.hoverActions = true

vim.lsp.set_log_level("debug")

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local config = {
	virtual_text = {
		source = "always", -- Or "if_many"
		prefix = '▎', -- Could be '●', '▎', 'x'
	},
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


local on_attach = function(client, bufnr)
	--print(vim.inspect(client.server_capabilities))
	vim.o.updatetime = 250
	vim.cmd [[autocmd! CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]

	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable()
	end
	if client.server_capabilities.codeLensProvider then
		vim.lsp.codelens.refresh()
	end
	if client.server_capabilities.documentHightlightProvider then
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
	if client.server_capabilities.signatureHelpProvider then
		vim.cmd [[autocmd! CursorHoldI * lua vim.lsp.buf.signature_help(nil, {focus=false})]]
		vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
			vim.lsp.handlers.signature_help,
			{
				border = 'rounded',
				close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
			}
		)
	end

	vim.lsp.handlers["textDocument/definition"] = function(_, result, ctx)
		if not result or vim.tbl_isempty(result) then
			return vim.api.nvim_echo({ { "Lsp: Could not find definition" } }, false, {})
		end

		if vim.tbl_islist(result) then
			local results = vim.lsp.util.locations_to_items(result, client.offset_encoding)
			local lnum, filename = results[1].lnum, results[1].filename
			for _, val in pairs(results) do
				if val.lnum ~= lnum or val.filename ~= filename then
					return require("telescope.builtin").lsp_definitions()
				end
			end
			vim.lsp.util.jump_to_location(result[1], client.offset_encoding, false)
		else
			vim.lsp.util.jump_to_location(result, client.offset_encoding, false)
		end
	end

	vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
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

	vim.lsp.handlers["textDocument/references"] = function(_, _, _)
		require("telescope.builtin").lsp_references()
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
	intelephense = require('configs.lspconfig.languages.intelephense').intelephense(capabilities, on_attach),
	texlab = require('configs.lspconfig.languages.texlab').texlab(capabilities, on_attach),
}

for server, cfg in pairs(servers) do
	lsp[server].setup(cfg)
end
