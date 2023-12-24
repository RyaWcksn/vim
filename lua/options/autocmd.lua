M = {}

M.autocmd = function()
	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function()
			local bufs_loaded = {}

			for _, buf_hndl in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf_hndl) then
					table.insert(bufs_loaded, vim.api.nvim_buf_get_name(buf_hndl))
				end
			end

			vim.o.winbar = "%<%{luaeval('table.concat(bufs_loaded, \\' \\' )')}>"
		end
	})
end

return M
