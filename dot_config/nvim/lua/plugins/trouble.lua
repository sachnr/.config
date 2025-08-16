return {
	"folke/trouble.nvim",
	keys = {
		{
			"<Leader>E",
			mode = "n",
			":Trouble diagnostics<CR>",
			{ silent = true, noremap = true },
		},
	},
	config = true,
}
