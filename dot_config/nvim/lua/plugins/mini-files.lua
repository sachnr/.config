return {
	{
		"echasnovski/mini.files",
		lazy = false,
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		keys = {
			{
				"<M-j><M-k>",
				mode = "n",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0))
				end,
				desc = "Open Mini.files at current file",
			},
		},
		config = function()
			local mini_files = require("mini.files")

			mini_files.setup({
				content = {
					filter = function(fs_entry)
						return not vim.startswith(fs_entry.name, ".")
					end,
				},
				mappings = {
					close = "q",
					go_in = "L",
					go_in_plus = "<CR>",
					go_out = "H",
					go_out_plus = "",
					mark_goto = "",
					mark_set = "",
					reset = "<C-R>",
					reveal_cwd = "<M-j><M-k>",
					show_help = "g?",
					synchronize = "",
					trim_left = "",
					trim_right = "",
				},
				options = {
					permanent_delete = true,
					use_as_default_explorer = true,
				},
				windows = {
					preview = false,
				},
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesBufferCreate",
				callback = function(args)
					local buf_id = args.data.buf_id

					vim.keymap.set("n", "<Leader>s", function()
						mini_files.synchronize()
					end, { buffer = buf_id, desc = "Save/Synchronize filesystem changes" })

					vim.keymap.set("n", "<C-s>", function()
						local fs_entry = mini_files.get_fs_entry()
						if fs_entry then
							mini_files.close()
							vim.cmd("split " .. fs_entry.path)
						end
					end, { buffer = buf_id, desc = "Open in horizontal split" })

					vim.keymap.set("n", "<C-v>", function()
						local fs_entry = mini_files.get_fs_entry()
						if fs_entry then
							mini_files.close()
							vim.cmd("vsplit " .. fs_entry.path)
						end
					end, { buffer = buf_id, desc = "Open in vertical split" })

					vim.keymap.set("n", "<C-t>", function()
						local fs_entry = mini_files.get_fs_entry()
						if fs_entry then
							mini_files.close()
							vim.cmd("tabnew " .. fs_entry.path)
						end
					end, { buffer = buf_id, desc = "Open in new tab" })

					vim.keymap.set("n", "<M-o>", function()
						local fs_entry = mini_files.get_fs_entry()
						if fs_entry then
							vim.ui.open(fs_entry.path)
						end
					end, { buffer = buf_id, desc = "Open with system default" })

					vim.keymap.set("n", "g.", function()
						mini_files.refresh({
							content = {
								filter = function(fs_entry)
									local current_filter = mini_files.config.content.filter
									if current_filter then
										return true
									else
										return not vim.startswith(fs_entry.name, ".")
									end
								end,
							},
						})
					end, { buffer = buf_id, desc = "Toggle hidden files" })
				end,
			})
		end,
	},
}
