return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.keymap.set("n", "<M-z>", function()
			require("snacks").zen()
		end, { silent = true, noremap = true })

		vim.notify = require("snacks").notifier.notify
	end,
	opts = {
		image = { enabled = true },
		bigfile = { enabled = true },
		zen = {},
		terminal = {},
		notifier = {
			enabled = true,
			timeout = 3000,
		},
	},
}
