function ToggleNetRW()
	if vim.bo.filetype ~= 'netrw' then
		vim.api.nvim_command('Ex')
	else
		vim.api.nvim_command('Rex')
		if vim.bo.filetype == 'netrw' then
			vim.api.nvim_command('bdel')
		end
	end
end

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 0
vim.g.netrw_bufsettings = 'nonu nornu noma nowrap nomod ro nobl'
vim.g.netrw_browse_split = 0                                         -- (4 to open in other window)
vim.g.netrw_altfile = 0
vim.g.netrw_list_hide = '^\\.\\.\\?/$,\\(^\\|\\s\\s\\)\\zs\\.\\S\\+' -- ALSO HIDE ./ and ../ when hidden files are shown
-- vim.g.netrw_list_hide = '\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'
--
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'netrw',
	callback = function()
		vim.api.nvim_command('setlocal buftype=nofile')
		vim.api.nvim_command('setlocal bufhidden=wipe')
		vim.opt_local.winbar = '%!v:lua.WinBarNetRW()'

		-- MAPPINGS
		local unbinds = {
			'<F1>', '<DEL>', '<C-H>', '<C-R>', '<C-TAB>', 'a', 'C', 'gb', 'gd', 'gf', 'gn', 'gp', 'i', 'mb',
			'md', 's', 'S', 't', 'v',
			'me', 'mF', 'mg', 'mh', 'mr', 'mT', 'mv', 'mx', 'mX', 'mz', 'o', 'O', 'p', 'P', 'qf', 'qF', 'qL',
			'r', 'X', 'I'
			-- '<cr>', '<c-l>', '-', 'd', 'D', 'gh', 'R', '%', 'mf', 'mm', 'mc', 'mu', 'cd', 'qb', 'u', 'U', 'x',
		}
		for _, value in pairs(unbinds) do
			vim.keymap.set('n', value, '<CMD>lua print("Keybind \'' .. value .. '\' has been removed")<CR>',
				{ noremap = true, silent = true, buffer = true })
		end
		vim.keymap.set('n', 'c', '%',
			{ desc = "Create File", noremap = true, silent = true, buffer = true })
		vim.keymap.set('n', 'mt', '<CMD>MT<CR>',
			{ desc = 'Mark Target', noremap = true, silent = true, buffer = true })
		vim.keymap.set('n', '<tab>', 'mfj', { desc = 'Mark File', remap = true, silent = true, buffer = true })
		vim.keymap.set('n', 'cd', function()
			vim.api.nvim_command('cd ' .. vim.fn.expand('%:~:p'))
			vim.api.nvim_command('MT n/a')
			print('Changed working directory: ' .. vim.fn.expand('%:~:p'))
		end, { desc = 'Change Directory', buffer = true })
		vim.keymap.set('n', '<BS>', '-', { desc = 'Go up', remap = true, buffer = true })
		vim.keymap.set('n', 'e', '<CMD>Ex ~<CR>', { desc = 'Go home', buffer = true })
		vim.keymap.set('n', 'w', '<CMD>Ex ' .. vim.fn.getcwd() .. '<CR>', { desc = 'Go CWD', buffer = true })
		vim.keymap.set('n', 't', function()
			local target = vim.api.nvim_call_function('netrw#Expose', { 'netrwmftgt' })
			if target == 'n/a' then
				print("No target directory set")
			elseif string.find(target, "^/") then
				vim.api.nvim_command('Ex ' .. target)
			else
				vim.api.nvim_command('Ex ' .. vim.fn.getcwd() .. '/' .. target)
			end
		end, { desc = 'Go to target', buffer = true })
		-- END MAPPINGS

		function TargetDir()
			local target = vim.api.nvim_call_function('netrw#Expose', { 'netrwmftgt' })
			if target == 'n/a' then
				return 'Target: None '
			else
				target = target:gsub("^" .. vim.loop.os_homedir(), "~")
				return 'Target: ' .. target .. ' '
			end
		end

		local function Hidden()
			local hidden = vim.g.netrw_list_hide
			if hidden == '^\\.\\.\\?/$,\\(^\\|\\s\\s\\)\\zs\\.\\S\\+' then
				return "%#StatuslineTextAccent#  Hide: On"
			else
				return "%#StatuslineTextAccent#  Hide: Off"
			end
		end

		local function Path()
			local path = vim.fn.expand('%:~:.') -- Relative
			-- local path = vim.fn.expand('%:~') -- Absolute
			return '%#StatusLineTextMain# ' .. path
		end

		WinBarNetRW = function()
			return table.concat {
				Path(),
				Hidden(),
				"%=",
				' ',
				TargetDir(),
				"%<",
			}
		end
		vim.opt_local.winbar = WinBarNetRW()
		-- vim.opt_local.statusline = WinBarNetRW()
	end
})
