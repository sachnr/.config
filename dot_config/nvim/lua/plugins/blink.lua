return {

	{
		"saghen/blink.cmp",
		dependencies = {
			"saghen/blink.lib",
		},
		build = function()
			require("blink.cmp").build():wait(60000)
		end,

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
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				menu = {
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
						components = {
							kind_icon = {
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							kind = {
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
					},
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = {
				enabled = true,
				window = {
					show_documentation = false,
				},
			},
		},
	},
}
