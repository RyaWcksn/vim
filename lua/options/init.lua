---@diagnostic disable: undefined-global
local opt = vim.opt
local g = vim.g

opt.fillchars = { eob = " " }

g.ultest_use_pty = 1
g.do_filetype_lua = 1

vim.notify = require("notify")

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.opt.background = "light" -- set this to dark or light
vim.cmd("colorscheme default")
vim.api.nvim_set_option('fileformat', 'unix')
opt.hlsearch = false
opt.undofile = true
opt.ruler = false
opt.hidden = true
opt.ignorecase = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = false
opt.cul = true
opt.mouse = "a"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.updatetime = 250 -- update interval for gitsigns
opt.timeoutlen = 400
opt.clipboard = "unnamed"
opt.clipboard:append { "unnamedplus" }
opt.foldenable = false
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.colorcolumn = "90"
vim.wo.wrap = false

-- Fold
local vim = vim
local api = vim.api
local M = {}
-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		api.nvim_command('augroup ' .. group_name)
		api.nvim_command('autocmd!')
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten { 'autocmd', def }, ' ')
			api.nvim_command(command)
		end
		api.nvim_command('augroup END')
	end
end

local autoCommands = {
	open_folds = {
		{ "BufReadPost,FileReadPost", "*", "normal zR" }
	}
}

M.nvim_create_augroups(autoCommands)


local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"matchparen",
	"tar",
	"tarPlugin",
	"rrhelper",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end


vim.g.gitblame_enabled = 0
vim.g.gitblame_message_template = "<summary> • <date> • <author>"
vim.g.gitblame_highlight_group = "LineNr"


vim.g.gist_open_browser_after_post = 1
