return {
	"ThePrimeagen/harpoon",
	lazy = false,
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()
		local opts = { silent = true, noremap = true }
		vim.keymap.set("n", "<C-;>a", function()
			harpoon:list():add()
		end, opts)
		vim.keymap.set("n", "<C-;>u", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, opts)
		vim.keymap.set("n", "<C-;>h", function()
			harpoon:list():select(1)
		end, opts)
		vim.keymap.set("n", "<C-;>j", function()
			harpoon:list():select(2)
		end, opts)
		vim.keymap.set("n", "<C-;>k", function()
			harpoon:list():select(3)
		end, opts)
		vim.keymap.set("n", "<C-;>l>", function()
			harpoon:list():select(4)
		end, opts)
	end,
}
