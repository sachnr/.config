return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local Snacks = require("snacks")

		Snacks.setup({
			image = { enabled = true },
			bigfile = { enabled = true },
			zen = { enabled = true },
			bufdelete = { enabled = true },
			git = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
		})

		vim.keymap.set("n", "<M-z>", function()
			Snacks.zen()
		end, { silent = true, noremap = true })

		vim.keymap.set("n", "<leader>gb", function()
			Snacks.git.blame_line()
		end, { silent = true, noremap = true })

		vim.notify = Snacks.notifier.notify
	end,
}
