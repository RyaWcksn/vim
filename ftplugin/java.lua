local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local lombok_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
local jar_path = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.expand('$HOME/Sandbox/workspace/') .. project_name
os.execute("mkdir -p " .. workspace_dir)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
--
local function get_config_dir()
	-- Unlike some other programming languages (e.g. JavaScript)
	-- lua considers 0 truthy!
	if vim.fn.has('linux') == 1 then
		return '/config_linux'
	elseif vim.fn.has('mac') == 1 then
		return '/config_mac'
	else
		return '/config_win'
	end
end
local jdtls = require('jdtls')
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config_path = jdtls_path .. get_config_dir()
local config = {
	cmd = {
		'java', -- or '/path/to/java17_or_newer/bin/java'
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		--'-javaagent:', lombok_path,
		'-Xmx1g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'-jar', jar_path,
		'-configuration', config_path,
		'-data', workspace_dir
	},
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
	root_dir = require('jdtls.setup').find_root({
		'.git',
		'mvnw',
		'gradlew',
		'pom.x',
		'build.gradle'
	}),
	sources = {
		organizeImports = {
			starThreshold = 9999,
			staticStarThreshold = 9999,
		},
	},
	eclipse = {
		downloadSources = true,
	},
	configuration = {
		updateBuildConfiguration = "interactive",
		runtimes = {
			name = "JavaSE-20",
			path = "/usr/lib/jvm/openjdk-20"
		}
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
	--local _, _ = pcall(vim.lsp.codelens.refresh)
	require('jdtls').setup_dap({ hotcodereplace = 'auto' })
	require("lsp-config").on_attach(client, bufnr)
	local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
	if status_ok then
		jdtls_dap.setup_dap_main_class_configs()
	end

	print('lsp server (jdtls) attached')
end

require('dap.ext.vscode').load_launchjs()
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
