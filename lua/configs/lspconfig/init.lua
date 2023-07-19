local lsp = require('lspconfig')

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

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	    virtual_text = true,
	    update_in_insert = false,
    })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

local on_references = vim.lsp.handlers["textDocument/references"]
vim.lsp.handlers["textDocument/references"] = vim.lsp.with(on_references, { loclist = true, virtual_text = true })

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Code actions
capabilities.textDocument.codeAction = {
	dynamicRegistration = true,
	codeActionLiteralSupport = {
		codeActionKind = {
			valueSet = (function()
				local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
				table.sort(res)
				return res
			end)(),
		},
	},
}

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}
capabilities.experimental = {}
capabilities.experimental.hoverActions = true


capabilities = require('cmp_nvim_lsp').default_capabilities()



-- inlay_hin0

local on_attach = function(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.buf.inlay_hint(0, true)
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
local default_workspace = {
	library = {
		"${3rd}/busted/library",
		"${3rd}/luassert/library",
		"${3rd}/luv/library",
	},

	maxPreload = 5000,
	preloadFileSize = 10000,
}
lsp.lua_ls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	codeLens = { enabled = true },
	settings = {
		Lua = {
			hint = { enable = true },
			telemetry = { enable = false },
			runtime = {
				version = "LuaJIT",
				special = {
					reload = "require",
				},
			},
			diagnostics = {
				globals = { "vim", "lvim", "reload" },
			},
			workspace = default_workspace,
		}
	}
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

lsp.rust_analyzer.setup({
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_dir = lsp.util.root_pattern("Cargo.toml", "rust-project.json"),
	settings = {
		['rust-analyzer'] = {
			diagnostics = {
				enable = false,
			}
		}
	},
	capabilities = {
		experimental = {
			serverStatusNotification = true
		},
		general = {
			positionEncodings = { "utf-16" }
		},
		textDocument = {
			callHierarchy = {
				dynamicRegistration = false
			},
			codeAction = {
				codeActionLiteralSupport = {
					codeActionKind = {
						valueSet = { "", "quickfix", "refactor", "refactor.extract",
							"refactor.inline", "refactor.rewrite", "source",
							"source.organizeImports" }
					}
				},
				dataSupport = true,
				dynamicRegistration = true,
				isPreferredSupport = true,
				resolveSupport = {
					properties = { "edit" }
				}
			},
			completion = {
				completionItem = {
					commitCharactersSupport = false,
					deprecatedSupport = false,
					documentationFormat = { "markdown", "plaintext" },
					preselectSupport = false,
					snippetSupport = false
				},
				completionItemKind = {
					valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
						20, 21, 22, 23, 24, 25 }
				},
				contextSupport = false,
				dynamicRegistration = false
			},
			declaration = {
				linkSupport = true
			},
			definition = {
				dynamicRegistration = true,
				linkSupport = true
			},
			documentHighlight = {
				dynamicRegistration = false
			},
			documentSymbol = {
				dynamicRegistration = false,
				hierarchicalDocumentSymbolSupport = true,
				symbolKind = {
					valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
						20, 21, 22, 23, 24, 25, 26 }
				}
			},
			formatting = {
				dynamicRegistration = true
			},
			hover = {
				contentFormat = { "markdown", "plaintext" },
				dynamicRegistration = true
			},
			implementation = {
				linkSupport = true
			},
			inlayHint = {
				dynamicRegistration = true,
				resolveSupport = {
					properties = {}
				}
			},
			publishDiagnostics = {
				relatedInformation = true,
				tagSupport = {
					valueSet = { 1, 2 }
				}
			},
			rangeFormatting = {
				dynamicRegistration = true
			},
			references = {
				dynamicRegistration = false
			},
			rename = {
				dynamicRegistration = true,
				prepareSupport = true
			},
			semanticTokens = {
				augmentsSyntaxTokens = true,
				dynamicRegistration = false,
				formats = { "relative" },
				multilineTokenSupport = false,
				overlappingTokenSupport = true,
				requests = {
					full = {
						delta = true
					},
					range = false
				},
				serverCancelSupport = false,
				tokenModifiers = { "declaration", "definition", "readonly", "static", "deprecated",
					"abstract", "async", "modification", "documentation", "defaultLibrary" },
				tokenTypes = { "namespace", "type", "class", "enum", "interface", "struct",
					"typeParameter", "parameter", "variable", "property", "enumMember", "event",
					"function", "method", "macro", "keyword", "modifier", "comment", "string",
					"number", "regexp", "operator", "decorator" }
			},
			signatureHelp = {
				dynamicRegistration = false,
				signatureInformation = {
					activeParameterSupport = true,
					documentationFormat = { "markdown", "plaintext" },
					parameterInformation = {
						labelOffsetSupport = true
					}
				}
			},
			synchronization = {
				didSave = true,
				dynamicRegistration = false,
				willSave = true,
				willSaveWaitUntil = true
			},
			typeDefinition = {
				linkSupport = true
			}
		},
		window = {
			showDocument = {
				support = true
			},
			showMessage = {
				messageActionItem = {
					additionalPropertiesSupport = false
				}
			},
			workDoneProgress = true
		},
		workspace = {
			applyEdit = true,
			configuration = true,
			didChangeWatchedFiles = {
				dynamicRegistration = true,
				relativePatternSupport = true
			},
			inlayHint = {
				refreshSupport = true
			},
			semanticTokens = {
				refreshSupport = true
			},
			symbol = {
				dynamicRegistration = false,
				symbolKind = {
					valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
						20, 21, 22, 23, 24, 25, 26 }
				}
			},
			workspaceEdit = {
				resourceOperations = { "rename", "create", "delete" }
			},
			workspaceFolders = true
		}
	}
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
