return {
	"folke/trouble.nvim",
	keys = {
		{
			"<Leader>E",
			mode = "n",
			"<cmd> Trouble diagnostics <CR>",
			desc = "trouble",
		},
	},
	config = true,
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
}
