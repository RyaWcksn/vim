local dap, dapui = require("dap"), require("dapui")
require('dap.ext.vscode').load_launchjs(nil, {})
require('dap').set_log_level('TRACE') -- Helps when configuring DAP, see logs with :DapShowLog
require('dap-go').setup()
dapui.setup()

-- dap.adapters.delve = {
-- 	type = 'server',
-- 	port = '${port}',
-- 	executable = {
-- 		command = 'dlv',
-- 		args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output="dap"', '--only-same-user=false' },
-- 	},
-- 	options = {
-- 		initialize_timeout_sec = 20,
-- 	},
-- }
dap.adapters.delve = {
	type = "server",
	host = "127.0.0.1",
	port = 38697,
}

dap.configurations.go = {
	{
		type = "delve",
		name = "Debug",
		request = "launch",
		program = "${file}"
	},
	{
		type = "delve",
		name = "Debug test", -- configuration for debugging test files
		request = "launch",
		mode = "test",
		program = "${file}"
	},
	-- works with go.mod packages and sub packages
	{
		type = "delve",
		name = "Debug test (go.mod)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}"
	}
}


dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
vim.fn.sign_define("DapBreakpoint", { text = "B=", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "S=", texthl = "", linehl = "", numhl = "" })


-- dap.configurations.go = {
-- 	{
-- 		type = "go",
-- 		name = "Debug",
-- 		request = "launch",
-- 		dlvToolPath = vim.fn.exepath('dlv'),
-- 		program = "${file}"
-- 	},
-- 	{
-- 		type = "go",
-- 		name = "Debug test", -- configuration for debugging test files
-- 		request = "launch",
-- 		mode = "test",
-- 		dlvToolPath = vim.fn.exepath('dlv'),
-- 		program = "${file}"
-- 	},
-- 	-- works with go.mod packages and sub packages
-- 	{
-- 		type = "go",
-- 		name = "Debug test (go.mod)",
-- 		request = "launch",
-- 		mode = "test",
-- 		dlvToolPath = vim.fn.exepath('dlv'),
-- 		program = "./${relativeFileDirname}"
-- 	}
-- }

-- dap.adapters.go = {
-- 	type = 'server',
-- 	port = '${port}',
-- 	executable = {
-- 		command = 'dlv',
-- 		args = { 'dap', '-l', '127.0.0.1:${port}' },
-- 		-- add this if on windows, otherwise server won't open successfully
-- 		-- detached = false
-- 	}
-- }



dap.configurations.scala = {
	{
		type = "scala",
		request = "launch",
		name = "RunOrTest",
		metals = {
			runType = "runOrTestFile",
			--args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
		},
	},
	{
		type = "scala",
		request = "launch",
		name = "Test Target",
		metals = {
			runType = "testTarget",
		},
	},
}
