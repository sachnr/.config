---@diagnostic disable: missing-fields
return {
	{
		"folke/zen-mode.nvim",
		keys = {
			{
				"<M-z>",
				mode = "n",
				function()
					local snacks = require("snacks")
					snacks.zen()
				end,
				desc = "zenmode",
			},
		},
		config = true,
	},
}
