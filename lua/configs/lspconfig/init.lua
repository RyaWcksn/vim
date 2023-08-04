local lsp = require('lspconfig')
local notify = require 'notify'

vim.o.updatetime = 250
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

vim.lsp.set_log_level("debug")

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  notify(result.message, lvl, {
    title = 'LSP | ' .. client.name,
    timeout = 10000,
    keep = function()
      return lvl == 'ERROR' or lvl == 'WARN'
    end,
  })
end

function PrintDiagnostics(opts, bufnr, line_nr, client_id)
	bufnr = bufnr or 0
	line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
	opts = opts or { ['lnum'] = line_nr }

	local line_diagnostics = vim.diagnostic.get(bufnr, opts)
	if vim.tbl_isempty(line_diagnostics) then return end

	local diagnostic_message = ""
	for i, diagnostic in ipairs(line_diagnostics) do
		diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
		print(diagnostic_message)
		if i ~= #line_diagnostics then
			diagnostic_message = diagnostic_message .. "\n"
		end
	end
	vim.api.nvim_echo({ { diagnostic_message, "Normal" } }, false, {})
end

vim.cmd [[ autocmd! CursorHold * lua PrintDiagnostics() ]]

local function goto_definition(split_cmd)
	local util = vim.lsp.util
	local log = require("vim.lsp.log")
	local api = vim.api

	-- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
	local handler = function(_, result, ctx)
		if result == nil or vim.tbl_isempty(result) then
			local _ = log.info() and log.info(ctx.method, "No location found")
			return nil
		end

		if split_cmd then
			vim.cmd(split_cmd)
		end

		if vim.tbl_islist(result) then
			util.jump_to_location(result[1])

			if #result > 1 then
				util.set_qflist(util.locations_to_items(result))
				api.nvim_command("copen")
				api.nvim_command("wincmd p")
			end
		else
			util.jump_to_location(result)
		end
	end

	return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition('split')

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
	if client.resolved_capabilities.document_highlight then
		vim.cmd [[
    hi! LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    hi! LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    hi! LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
  ]]
		vim.api.nvim_create_augroup('lsp_document_highlight', {
			clear = false
		})
		vim.api.nvim_clear_autocmds({
			buffer = bufnr,
			group = 'lsp_document_highlight',
		})
		vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
			group = 'lsp_document_highlight',
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
			group = 'lsp_document_highlight',
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
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
	lsp[server].setup(cfg)
end
