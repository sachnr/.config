return {
	{
		"b0o/incline.nvim",
		config = function()
			local devicons = require("nvim-web-devicons")
			require("incline").setup({
				window = {
					padding = 0,
					margin = { horizontal = 0 },
					options = {
						winblend = 30,
					},
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if filename == "" then
						filename = "[No Name]"
					end
					local ft_icon, ft_color = devicons.get_icon_color(filename)
					local modified = vim.bo[props.buf].modified
					-- local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
					-- local bg = hl and hl.background and string.format("#%06x", hl.background)
					local bg = "NONE"
					return {
						ft_icon and { " ", ft_icon, " ", guibg = bg, guifg = ft_color } or "",
						" ",
						{ filename, gui = modified and "bold,italic" or "bold" },
						" ",
						guibg = bg,
					}
				end,
			})
		end,
		event = "VeryLazy",
	},
}
