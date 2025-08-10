return {
	"saghen/blink.cmp",
	version = "1.*",
	opts = {
		keymap = {
			-- set to 'none' to disable the 'default' preset
			preset = "none",
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<C-e>"] = false,
			["C-y"] = { "accept" },
			["C-k"] = { "show_documentation" },
			["M-n"] = { "snippet_forward" },
			["M-p"] = { "snippet_backward" },
		},
		appearance = {
			nerd_font_variant = "normal",
		},
		completion = { documentation = { auto_show = false } },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		fuzzy = { implementation = "prefer_rust" },
		signature = { enabled = true },
		documentation = { auto_show = true, auto_show_delay_ms = 500 },
	},
	opts_extend = { "sources.default" },
}
