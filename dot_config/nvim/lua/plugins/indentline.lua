return {
	{
		"nvim-mini/mini.indentscope",
		version = "*",
		config = function()
			require("mini.indentscope").setup({
				symbol = "▏",

				draw = {
					delay = 0,
					animation = require("mini.indentscope").gen_animation.none(),
				},

				options = {
					border = "top",
					indent_at_cursor = false,
					try_as_border = true,
					n_lines = 500,
				},

				mappings = {
					object_scope = "",
					object_scope_with_border = "",
					goto_top = "",
					goto_bottom = "",
				},
			})

			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", {
				fg = "#5f5f5f",
				nocombine = true,
			})
		end,
	},
}
