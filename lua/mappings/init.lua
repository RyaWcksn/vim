vim.g.mapleader = " "

local opt = { silent = true, noremap = true }
local keymap = vim.keymap.set

-- Resize split panes
keymap('n', '<M-UP>', '<cmd>resize +2<cr>', opt)
keymap('n', '<M-DOWN>', '<cmd>resize -2<cr>', opt)
keymap('n', '<M-LEFT>', '<cmd>vertical resize +2<cr>', opt)
keymap('n', '<M-RIGHT>', '<cmd>vertical resize -2<cr>', opt)

-- Search and replace in visual selection
keymap('x', '<leader>/', [[:s/\%V]], opt)

keymap({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

keymap({ 'n' }, '<F3>', "zc", { desc = "Fold" })
keymap({ 'n' }, '<F4>', "zR", { desc = "Unfold all" })
keymap({ 'n' }, '<F5>', "zo", { desc = "Unfold" })

keymap('n', "<F7>", "%s/\r//g", { desc = "Remove carriage-enter" })

-- Function to exit visual mode
local function exit_visual_mode()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
end

keymap('n', '<bs>', '<c-^>\'”zz', { desc = "Prev buffer" })

-- Stuff
keymap("n", "J", "mzJ`z", opt)
keymap("n", "Y", "y$", opt)
keymap("n", "N", "Nzzzv", opt)
keymap("n", "n", "nzzzv", opt)
keymap('n', '<c-k>', ':m -2<CR>==', opt)
keymap('n', '<c-j>', ':m +1<CR>==', opt)
keymap('v', '<M-k>', ":m '<-2<CR>gv=gv", opt)
keymap('v', '<M-j>', ":m '>+1<CR>gv=gv", opt)

-- Add blank line without leaving normal mode
keymap('n', '<leader>o', 'o<Esc>', opt)
keymap('n', '<leader>O', 'O<Esc>', opt)

-- Delete word with backspace
keymap('n', '<C-BS>', 'a<C-w>', opt)

-- Indent
keymap("v", "J", ":m '>+1<CR>gv=gv", opt)
keymap("v", "K", ":m '<-2<CR>gv=gv", opt)
keymap("v", "L", ">gv", opt)
keymap("v", "H", "<gv", opt)

-- Using ; to Command mode
-- keymap("n", ";", ":", {})

-- Using jk as ESC
keymap("t", "jk", "<C-\\><C-n>", opt)
keymap({ "i", "v" }, "jk", "<esc>", opt)

-- Terminal Float
keymap("t", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)
keymap("i", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)
keymap("n", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)

-- Search and replace word under the cursor
keymap('n', '<leader>R', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>',
	{ desc = 'Search and replace word under the cursor' })

-- Carbon Now Sha
keymap("v", "<F5>", ":CarbonNowSh<CR>", opt)

keymap("n", "<Up>", "<C-u>", opt)
keymap("n", "<Down>", "<C-d>", opt)

-- Vim
keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", opt)
keymap('n', '[', ":lua vim.diagnostic.goto_prev()<CR>", opt)
keymap('n', ']', ":lua vim.diagnostic.goto_next()<CR>", opt)
keymap('i', '<c-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opt)

local function netrw_mapping()
	local bufmap = function(lhs, rhs)
		local opts = { buffer = true, remap = true }
		vim.keymap.set('n', lhs, rhs, opts)
	end

	-- Better navigation
	bufmap('H', 'u')
	bufmap('h', '-^')
	bufmap('l', '<CR>')
	bufmap('L', '<CR>:Lexplore<CR>')
	bufmap('a', '%:w<CR>:buffer #<CR>')
	bufmap('fr', 'r')
	bufmap('q', ':q<CR>')

	-- Toggle dotfiles
	bufmap('.', 'gh')
end

local user_cmds = vim.api.nvim_create_augroup('user_cmds', { clear = true })
vim.api.nvim_create_autocmd('filetype', {
	pattern = 'netrw',
	group = user_cmds,
	desc = 'Keybindings for netrw',
	callback = netrw_mapping
})
