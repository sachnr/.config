return {
	"rhysd/conflict-marker.vim",

	{
		"lewis6991/gitsigns.nvim",
		keys = {
			{
				"<leader>gb",
				function()
					require("gitsigns").blame_line()
				end,
				{ desc = "git blame" },
			},
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
