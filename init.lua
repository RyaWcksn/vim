require('plugins')
require('options')
require('mappings')
require('options.statusline').setup()


local current_filename = vim.api.nvim_buf_get_name(0)
print(current_filename)
