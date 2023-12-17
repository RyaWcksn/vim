M = {}


M.setup = function()
	local modes = {
		["n"] = "NO",
		["no"] = "NO",
		["v"] = "VI",
		["V"] = "VI",
		[""] = "VI",
		["s"] = "SE",
		["S"] = "SE",
		[""] = "SE",
		["i"] = "IN",
		["ic"] = "IN",
		["R"] = "RE",
		["Rv"] = "VI",
		["c"] = "CMD",
		["cv"] = "VIX",
		["ce"] = "EX",
		["r"] = "PROMPT",
		["rm"] = "MOAR",
		["r?"] = "CONFIRM",
		["!"] = "SH",
		["t"] = "TERM",
	}

	local function mode()
		local current_mode = vim.api.nvim_get_mode().mode
		return string.format(" %s ", modes[current_mode]):upper()
	end

	local function update_mode_colors()
		local current_mode = vim.api.nvim_get_mode().mode
		local mode_color = "%#StatusLineAccent#"
		if current_mode == "n" then
			mode_color = "%#StatuslineAccent#"
		elseif current_mode == "i" or current_mode == "ic" then
			mode_color = "%#StatuslineInsertAccent#"
		elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
			mode_color = "%#StatuslineVisualAccent#"
		elseif current_mode == "R" then
			mode_color = "%#StatuslineReplaceAccent#"
		elseif current_mode == "c" then
			mode_color = "%#StatuslineCmdLineAccent#"
		elseif current_mode == "t" then
			mode_color = "%#StatuslineTerminalAccent#"
		end
		return mode_color
	end


	local function filepath()
		local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
		if fpath == "" or fpath == "." then
			return " "
		end

		return string.format(" %%<%s/", fpath)
	end

	local function filename()
		local fname = vim.fn.expand "%:t"
		if fname == "" then
			return ""
		end
		return fname .. " "
	end

	local function filetype()
		return string.format(" %s ", vim.bo.filetype):upper()
	end

	local function lsp()
		local count = {}
		local levels = {
			errors = "Error",
			warnings = "Warn",
			info = "Info",
			hints = "Hint",
		}

		for k, level in pairs(levels) do
			count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
		end

		local errors = ""
		local warnings = ""
		local hints = ""
		local info = ""

		if count["errors"] ~= 0 then
			errors = " %#LspDiagnosticsSignError#ERR " .. count["errors"]
		end
		if count["warnings"] ~= 0 then
			warnings = " %#LspDiagnosticsSignWarning#WARN " .. count["warnings"]
		end
		if count["hints"] ~= 0 then
			hints = " %#LspDiagnosticsSignHint#HINT " .. count["hints"]
		end
		if count["info"] ~= 0 then
			info = " %#LspDiagnosticsSignInformation#INFO " .. count["info"]
		end


		return errors .. warnings .. hints .. info .. "%#Normal#"
	end

	local function lsp_servers()
		local msg = 'No Active Lsp'
		local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
		local clients = vim.lsp.get_active_clients()
		local names = {}
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				table.insert(names, client.name)
			end
		end
		if #names == 0 then
			return msg
		else
			return string.format(" LSP Servers : [ %s ]", table.concat(names, ', '))
		end
	end

	local function get_git_branch()
		local handle = io.popen('git rev-parse --abbrev-ref HEAD 2>/dev/null')
		local result = handle:read('*l')
		handle:close()
		result = string.format(" Branch : %s ", result)
		return result or ''
	end

	Statusline = {}

	Statusline.active = function()
		return table.concat {
			"%#Statusline#",
			update_mode_colors(),
			mode(),
			"%#Normal# ",
			"%#Normal#",
			lsp(),
			lsp_servers(),
			get_git_branch(),
			filepath(),
			filename(),
			"%=%#StatusLineExtra#",
			filetype(),
		}
	end

	function Statusline.inactive()
		return " %F"
	end

	function Statusline.short()
		return "%#StatusLineNC#   NvimTree"
	end

	vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
  augroup END
]], false)
end

return M
