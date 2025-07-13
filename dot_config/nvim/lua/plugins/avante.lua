return {
	{
		"yetone/avante.nvim",
		build = function()
			return "make"
		end,
		event = "VeryLazy",
		version = false,
		opts = {
			provider = "gemini",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
	},
}
