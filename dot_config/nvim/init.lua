local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

vim.opt.equalalways = false
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.laststatus = 0
vim.opt.lazyredraw = true
vim.opt.number = true
vim.opt.redrawtime = 1500
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.shiftwidth = 4
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.showbreak = "» "
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum,fuzzy"
vim.opt.pumheight = 15
vim.opt.diffopt = "internal,filler,algorithm:histogram"
vim.opt.showcmdloc = "statusline"
vim.opt.winborder = "rounded"

-- keybinds
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, noremap = true })
vim.keymap.set("n", "<ESC>", "<cmd> noh <CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<space>s", "<cmd> w <CR>", { silent = true, noremap = true })
vim.keymap.set("i", "<C-c>", "<ESC>", { silent = true, noremap = true })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })
vim.keymap.set("n", "<leader>gh", ":diffget //2<CR>", { desc = "Get left" })
vim.keymap.set("n", "<leader>gl", ":diffget //3<CR>", { desc = "Get right" })
vim.keymap.set("n", "<leader>gs", ":Gvdiffsplit! <CR>", { desc = "threeway split" })

local close_quickfix = vim.api.nvim_create_augroup("close_quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = close_quickfix,
	pattern = {
		"help",
		"qf",
		"lspinfo",
		"man",
		"quickfix",
		"checkhealth",
	},
	command = [[
            nnoremap <buffer><silent> q :close<CR>
            set nobuflisted
        ]],
})

-- quick terminal
vim.keymap.set("n", "<leader>st", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 10)
	vim.cmd("startinsert")
end)

require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
})

require("cyberdream").setup({
	transparent = true,
})
vim.cmd.colorscheme("cyberdream")

if vim.g.neovide then
	vim.o.guifont = "Iosevka Curly Slab:h14"
	vim.g.neovide_text_gamma = 0.0
	vim.g.neovide_text_contrast = 0

	vim.g.neovide_position_animation_length = 0.04
	vim.g.neovide_cursor_animation_length = 0.05
	vim.g.neovide_cursor_short_animation_length = 0.02
	vim.g.neovide_scroll_animation_length = 0.08
	vim.g.neovide_scroll_animation_far_lines = 2

	vim.g.neovide_cursor_trail_size = 0

	vim.g.neovide_cursor_animate_in_insert_mode = true
	vim.g.neovide_cursor_animate_command_line = true
	vim.g.neovide_cursor_antialiasing = true

	vim.g.neovide_refresh_rate = 180
	vim.g.neovide_refresh_rate_idle = 5
end
