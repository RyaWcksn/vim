---@diagnostic disable: undefined-global
local opt = vim.opt
local g = vim.g

opt.fillchars = { eob = " " }

g.ultest_use_pty = 1
g.do_filetype_lua = 1

vim.notify = require("notify")



-- Call the function to get the number of LSP buffers and print it

local function status_line()
	local file_name = vim.api.nvim_eval_statusline("%f", {}).str
	local modified = " %-m"
	local file_type = " %y"

	file_name = file_name:gsub('/', ' > ')

	return string.format(
		"%s %s %s",
		file_type,
		file_name,
		modified
	)
end

vim.opt.winbar = status_line()


vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.opt.background = "dark" -- set this to dark or light
vim.cmd("colorscheme oxocarbon")


opt.hlsearch = false
opt.undofile = true
opt.ruler = false
opt.hidden = true
opt.ignorecase = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.cul = true
opt.mouse = "a"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.updatetime = 250 -- update interval for gitsigns
opt.timeoutlen = 400
opt.clipboard = "unnamed"
opt.clipboard:append { "unnamedplus" }
opt.foldenable = false
-- opt.foldmethod = "indent"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
--
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
--opt.colorcolumn="90"
vim.wo.wrap = false
-- Outline


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
