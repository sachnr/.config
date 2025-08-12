vim.g.mapleader = " "
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.cursorline = true
-- vim.opt.fillchars = { stl = " ", eob = " " }
vim.opt.fileencoding = "utf-8"
-- vim.opt.equalalways = false
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
-- vim.opt.tabstop = 4
-- vim.opt.softtabstop = 4
-- vim.opt.shiftwidth = 4
-- vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(" ", 3)
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.updatetime = 600
vim.opt.timeoutlen = 400
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.signcolumn = "no"
vim.opt.swapfile = false
vim.o.winborder = "rounded"

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

vim.api.nvim_create_user_command("InlayHintToggle", function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
end, { nargs = 0 })

vim.keymap.set("n", "\\", function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
end, { silent = true, noremap = true, desc = "Toggle Inlay Hints" })

vim.api.nvim_create_autocmd("FileType", {
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

vim.keymap.set("n", "<leader>st", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 10)
	vim.cmd("startinsert")
end)

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

require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
})

require("statusline").setup()
require("lsp")

if vim.g.neovide then
	vim.o.guifont = "Iosevka Term:h14"
	vim.g.neovide_text_gamma = 0.0
	vim.g.neovide_text_contrast = 0
	-- vim.g.neovide_position_animation_length = 0
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_trail_size = 0
	vim.g.neovide_cursor_animate_in_insert_mode = false
	vim.g.neovide_cursor_animate_command_line = false
	-- vim.g.neovide_scroll_animation_far_lines = 0
	-- vim.g.neovide_scroll_animation_length = 0
	vim.g.neovide_refresh_rate = 180
	vim.g.neovide_refresh_rate_idle = 5
end

require("cyberdream").setup({
	transparent = true,
})
vim.cmd.colorscheme("cyberdream")
