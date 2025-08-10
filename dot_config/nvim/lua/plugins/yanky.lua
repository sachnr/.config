return {
	"gbprod/yanky.nvim",
	keys = {
		{ "y", mode = { "n", "x" }, "<Plug>(YankyYank)", desc = "Yanky Yank" },
		{ "p", mode = { "n", "x" }, "<Plug>(YankyPutAfter)", desc = "Yanky Put After" },
		{ "P", mode = { "n", "x" }, "<Plug>(YankyPutBefore)", desc = "Yanky Put Before" },
		{ "<c-n>", mode = "n", "<Plug>(YankyCycleForward)", desc = "Yanky Cycle Forward" },
		{ "<c-p>", mode = "n", "<Plug>(YankyCycleBackward)", desc = "Yanky Cycle Back" },
		{ "<leader>p", mode = { "n", "x" }, "<cmd> Telescope yank_history <CR>", desc = "Paste from Yanky" },
	},
	config = function()
		require("yanky").setup({
			storage = "shada",
			system_clipboard = {
				sync_with_ring = true,
			},
		})
	end,
}
