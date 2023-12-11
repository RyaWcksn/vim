local M = {}

M.lua_ls = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local default_workspace = {
		library = {
			"${3rd}/busted/library",
			"${3rd}/luassert/library",
			"${3rd}/luv/library",
			vim.api.nvim_get_runtime_file("", true),
		},

		checkThirdParty = false,
		maxPreload = 5000,
		preloadFileSize = 10000,
	}
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		codeLens = { enabled = true },
		root_dir = lsp.util.root_pattern(".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml",
			"stylua.toml", "selene.toml", "selene.yml", ".git"),
		settings = {
			Lua = {
				hint = { enable = true },
				elemetry = { enable = false },
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
	return setup
end

return M

