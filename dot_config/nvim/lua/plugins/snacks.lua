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
			terminal = { enabled = true },
			rename = { enabled = true },
			bufdelete = { enabled = true },
			statuscolumn = { enabled = true },
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

		vim.api.nvim_create_autocmd("User", {
			pattern = "OilActionsPost",
			callback = function(event)
				if event.data.actions.type == "move" then
					Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
				end
			end,
		})

		vim.api.nvim_create_autocmd("BufHidden", {
			pattern = "*.png,*.jpg,*.jpeg,*.gif",
			callback = function(args)
				local bufnr = args.buf
				Snacks.bufdelete.delete({ buf = bufnr, force = true })
			end,
		})

		vim.notify = Snacks.notifier.notify
	end,
}
