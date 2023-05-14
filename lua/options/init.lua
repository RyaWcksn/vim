local opt = vim.opt
local g = vim.g

opt.fillchars = { eob = " " }

g.ultest_use_pty = 1
g.do_filetype_lua = 1


vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.cmd.colorscheme("noirbuddy")


vim.o.background = style
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

