return {
	"rhysd/conflict-marker.vim",

	{
		"lewis6991/gitsigns.nvim",
		keys = {
			{ "<leader>gb", "<cmd> lua require('gitsigns').blame_line <cr>", { desc = "git blame" } },
		},
		config = function()
			require("gitsigns").setup({
				numhl = false,
			})
		end,
	},

	{
		"tpope/vim-fugitive",
	},
}
