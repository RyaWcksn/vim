local capabilities = vim.lsp.protocol.make_client_capabilities()
local jdtls = require('jdtls')
require('dap.ext.vscode').load_launchjs()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
local config = {
	cmd = { 'jdtls' },
	root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
	single_file_support = true,
	settings = {
		flags = {
			allow_incremental_sync = true,
		},
		init_options = {
		},
	},
	signatureHelp = { enabled = true },
	contentProvider = { preferred = 'fernflower' },
	sources = {
		organizeImports = {
			starThreshold = 9999,
			staticStarThreshold = 9999,
		},
	},
	eclipse = {
		downloadSources = true,
	},
	maven = {
		downloadSources = true,
	},
	implementationsCodeLens = {
		enabled = true,
	},
	referencesCodeLens = {
		enabled = true,
	},
	references = {
		includeDecompiledSources = true,
	},
	capabilities = capabilities,
	inlayHints = {
		parameterNames = {
			enabled = "all", -- literals, all, none
		},
	},
	completion = {
		favoriteStaticMembers = {
			-- "org.hamcrest.MatcherAssert.assertThat",
			-- "org.hamcrest.Matchers.*",
			-- "org.hamcrest.CoreMatchers.*",
			"org.junit.jupiter.api.Assertions.*",
			"java.util.Objects.requireNonNull",
			"java.util.Objects.requireNonNullElse",
			"org.mockito.Mockito.*",
			"java.util.stream.Collectors.*",
			"org.assertj.core.api.Assertions.*"
		},
		filteredTypes = {
			"com.sun.*",
			"io.micrometer.shaded.*",
			"java.awt.*",
			"jdk.*", "sun.*",
		},
	},
	codeGeneration = {
		toString = {
			template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
		},
		hashCodeEquals = {
			useJava7Objects = true,
		},
		useBlocks = true,
	},
	extendedClientCapabilities = extendedClientCapabilities
}
config['on_attach'] = function(client, bufnr)
	local _, _ = pcall(vim.lsp.codelens.refresh)
	require('jdtls').setup_dap({ hotcodereplace = 'auto' })
	require("lsp-config").on_attach(client, bufnr)
	local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
	if status_ok then
		jdtls_dap.setup_dap_main_class_configs()
	end

	vim.notify('lsp server (jdtls) attached')
end
jdtls.start_or_attach(config)
