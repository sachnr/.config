return {
	{ "scottmckendry/cyberdream.nvim", opts = { transparent = true } },
	"mellow-theme/mellow.nvim",
	{ "folke/tokyonight.nvim", opts = { transparent = true } },
	"rebelot/kanagawa.nvim",
	"Shatur/neovim-ayu",
	"Mofiqul/dracula.nvim",
	"ellisonleao/gruvbox.nvim",
	"neanias/everforest-nvim",
	"EdenEast/nightfox.nvim",
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "ribru17/bamboo.nvim", opts = { transparent = false } },
	"ramojus/mellifluous.nvim",
	"p00f/alabaster.nvim",
	{ "rose-pine/neovim", name = "rose-pine" },
	"maxmx03/solarized.nvim",
	{
		"catppuccin/nvim",
		name = "sakura",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				color_overrides = {
					mocha = {
						base = "#0d0509",
						mantle = "#0d0509",
						crust = "#0d0509",
						text = "#f0eaed",
						subtext0 = "#D1B399",
						subtext1 = "#E3C5AB",
						surface0 = "#1a0f15",
						surface1 = "#2a1f25",
						surface2 = "#33333c",
						overlay0 = "#4a3c45",
						overlay1 = "#5a4c55",
						overlay2 = "#6a5c65",
						red = "#E85F6F",
						maroon = "#FF7A8A",
						peach = "#D4A882",
						yellow = "#E6BA94",
						green = "#F29B9A",
						teal = "#E8C099",
						sky = "#D9A56C",
						sapphire = "#EBB97E",
						blue = "#D9A56C",
						lavender = "#E3C5AB",
						pink = "#FF7A8A",
						rosewater = "#f0eaed",
						flamingo = "#FFB5B4",
					},
				},
			})
		end,
	},

	{
		"bjarneo/aether.nvim",
		branch = "v3",
		name = "aether",
		priority = 1000,
		opts = {
			colors = {
				bg = "#dfe4c4",
				dark_bg = "#dfe4c4",
				darker_bg = "#d8d9b8",
				lighter_bg = "#ecebbd",

				fg = "#1c2d28",
				dark_fg = "#253631",
				light_fg = "#858f8b",
				bright_fg = "#acb3b1",
				muted = "#606c68",

				red = "#9d2e3a", -- deeper red (errors, vars)
				orange = "#c45d2e", -- better orange (numbers, constants)
				yellow = "#b56b2e", -- warm class/type yellow
				green = "#4a6b4a", -- deeper forest green (strings)
				cyan = "#2a7a8a", -- stronger cyan
				blue = "#3a6a9a", -- richer function/keyword blue
				purple = "#5a4a7a", -- deeper purple
				brown = "#8a5a6a", -- warm deprecated

				bright_red = "#c23d4a",
				bright_yellow = "#d47a3a",
				bright_green = "#5a8a5a",
				bright_cyan = "#3a9aa8",
				bright_blue = "#4a7ab8",
				bright_purple = "#6a5a9a",

				accent = "#3a6a9a",
				cursor = "#1c2d28",
				foreground = "#1c2d28",
				background = "#dfe4c4",
				selection = "#c8d4a8", -- soft selection bg
				selection_foreground = "#1c2d28",
				selection_background = "#5e81ac",
			},
		},
	},
}
