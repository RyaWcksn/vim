vim.g.mapleader = " "

local opt = { silent = true, noremap = true }
local key = vim.api.nvim_set_keymap

-- Disable key

-- Stuff
key("n", "Y", "y$", opt)
key("n", "J", "mzJ`z", opt)
key("n", "n", "nzzzv", opt)
key("n", "N", "Nzzzv", opt)
key("n", "<C-L>", "zL", opt)
key("n", "<C-H>", "zH", opt)


-- Indent
key("v", "J", ":m '>+1<CR>gv=gv", opt)
key("v", "K", ":m '<-2<CR>gv=gv", opt)
key("v", "L", ">gv", opt)
key("v", "H", "<gv", opt)

-- Using ; to Command mode
key("n", ";", ":", opt)

-- Using jk as ESC
key("t", "jk", "<C-\\><C-n>", opt)
key("i", "jk", "<esc>", opt)

-- Terminal Float
key("t", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)
key("i", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)
key("n", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)

-- Hop word
key("n", "W", ":HopWord<CR>", opt)

-- Carbon Now Sha
key("v", "<F5>", ":CarbonNowSh<CR>", opt)


key("n", "<Up>", "<C-u>", opt)
key("n", "<Down>", "<C-d>", opt)

-- Vim
key("n", "K", ":lua vim.lsp.buf.hover()<CR>", opt)
key('n', '[', ":lua vim.diagnostic.goto_prev()<CR>", opt)
key('n', ']', ":lua vim.diagnostic.goto_next()<CR>", opt)

-- key("n", "hh", "zc", opt)
-- key("n", "ll", "zo", opt)

-- Unix specified keybinding, using meta as leader key
