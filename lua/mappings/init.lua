vim.g.mapleader = " "

local opt = { silent = true, noremap = true }
local key = vim.keymap.set

-- Resize split panes
key('n', '<M-UP>', '<cmd>resize +2<cr>', opt)
key('n', '<M-DOWN>', '<cmd>resize -2<cr>', opt)
key('n', '<M-LEFT>', '<cmd>vertical resize +2<cr>', opt)
key('n', '<M-RIGHT>', '<cmd>vertical resize -2<cr>', opt)

-- Search and replace in visual selection
key('x', '<leader>/', [[:s/\%V]], opt)

key({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
key({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Stuff
key("n", "Y", "y$", opt)
key("n", "J", "mzJ`z", opt)
key("n", "N", "Nzzzv", opt)
key("n", "n", "nzzzv", opt)
key('n', '<c-k>', ':m -2<CR>==', opt)
key('n', '<c-j>', ':m +1<CR>==', opt)
-- key.keymap.set('i', '<c-k>', '<esc><cmd>m .-2<cr>==gi')
-- key.keymap.set('i', '<c-j>', '<esc><cmd>m .+1<cr>==gi')
key('v', '<c-k>', ":m '<-2<CR>gv=gv", opt)
key('v', '<c-j>', ":m '>+1<CR>gv=gv",opt)

-- Add blank line without leaving normal mode
key('n', '<leader>o', 'o<Esc>',opt)
key('n', '<leader>O', 'O<Esc>',opt)

-- Delete word with backspace
key('n', '<BS>', 'ge', opt)
key('n', '<C-BS>', 'a<C-w>', opt)

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

-- Search and replace word under the cursor
key('n', '<leader>R', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>',  { desc = 'Search and replace word under the cursor' })

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
