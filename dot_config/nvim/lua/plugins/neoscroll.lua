return {
	{
		"karb94/neoscroll.nvim",
		config = function()
			local neoscroll = require("neoscroll")

			neoscroll.setup({
				hide_cursor = true,
				stop_eof = false,
				respect_scrolloff = false,
				cursor_scrolls_alone = true,
				duration_multiplier = 0.30,
				easing = "cubic",
				performance_mode = true,
				ignored_events = {
					"WinScrolled",
					"CursorMoved",
					"DiagnosticChanged",
				},
			})

			local map = vim.keymap.set

			map({ "n", "v", "x" }, "<C-u>", function()
				neoscroll.ctrl_u({
					duration = 120,
				})
			end, { silent = true })

			map({ "n", "v", "x" }, "<C-d>", function()
				neoscroll.ctrl_d({
					duration = 120,
				})
			end, { silent = true })

			map({ "n", "v", "x" }, "<C-b>", function()
				neoscroll.ctrl_b({
					duration = 180,
				})
			end, { silent = true })

			map({ "n", "v", "x" }, "<C-f>", function()
				neoscroll.ctrl_f({
					duration = 180,
				})
			end, { silent = true })

			map("n", "zz", function()
				neoscroll.zz({
					half_win_duration = 80,
				})
			end, { silent = true })

			map("n", "zt", function()
				neoscroll.zt({
					half_win_duration = 80,
				})
			end, { silent = true })

			map("n", "zb", function()
				neoscroll.zb({
					half_win_duration = 80,
				})
			end, { silent = true })
		end,
	},
}
