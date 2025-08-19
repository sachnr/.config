return {
	{
		"saghen/blink.compat",
		version = "2.*",
		lazy = true,
		opts = {},
	},

	{
		"saghen/blink.cmp",
		dependencies = {
			{ "MattiasMTS/cmp-dbee", ft = "sql", opts = {} },
		},
		version = "1.*",
		opts = {
			keymap = {
				preset = "none",
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<C-e>"] = false,
				["<C-y>"] = { "accept" },
				["<C-k>"] = { "show_documentation" },
				["<M-n>"] = { "snippet_forward" },
				["<M-p>"] = { "snippet_backward" },
			},
			appearance = {
				nerd_font_variant = "normal",
			},
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "cmp-dbee" },
				providers = {
					["cmp-dbee"] = {
						name = "cmp-dbee",
						module = "blink.compat.source",
					},
				},
			},
			fuzzy = { implementation = "prefer_rust" },
			signature = {
				enabled = true,
				window = {
					show_documentation = false,
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
