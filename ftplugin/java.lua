local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local lombok_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
local jar_path = jdtls_path .. '/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.expand('$HOME/Sandbox/workspace/') .. project_name
local capabilities = vim.lsp.protocol.make_client_capabilities()
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

local config_path = jdtls_path .. get_config_dir()
local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		-- 💀
		'java', -- or '/path/to/java17_or_newer/bin/java'
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-javaagent:', lombok_path,
		'-Xmx1g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
		'-jar', jar_path,
		'-configuration', config_path,
		'-data', workspace_dir
	},

	-- 💀
	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
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
	inlayHints = {
		parameterNames = {
			enabled = "all", -- literals, all, none
		},
	},
	codeGeneration = {
		toString = {
			template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
		}
	},
	capabilities = capabilities


}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
