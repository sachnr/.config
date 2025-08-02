return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.keymap.set("n", "<M-z>", function()
			require("snacks").zen()
		end, { silent = true, noremap = true })

		vim.keymap.set("n", "<leader>gb", function()
			require("snacks").git.blame_line()
		end, { silent = true, noremap = true })

		vim.api.nvim_create_autocmd("User", {
			pattern = "OilActionsPost",
			callback = function(event)
				if event.data.actions.type == "move" then
					require("snacks").rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
				end
			end,
		})

		vim.notify = require("snacks").notifier.notify
	end,
	opts = {
		image = { enabled = true },
		bigfile = { enabled = true },
		zen = {},
		terminal = {},
		rename = {},
		statuscolumn = {},
		git = {},
		notifier = {
			enabled = true,
			timeout = 3000,
		},
	},
}
