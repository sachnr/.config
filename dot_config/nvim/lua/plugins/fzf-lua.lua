local opts = { silent = true, noremap = true }

return {
	{
		"ibhagwan/fzf-lua",
		keys = {
			{ "<leader>tf", ":FzfLua files<CR>", opts },
			{ "<leader>to", ":FzfLua oldfiles<CR>", opts },
			{ "<leader>t/", ":FzfLua lgrep_curbuf<CR>", opts },
			{ "<leader>tg", ":FzfLua live_grep_native<CR>", opts },
			{ "<leader>tq", ":FzfLua quickfix<CR>", opts },
			{ "<leader>th", ":FzfLua lsp_document_symbols<CR>", opts },
			{ "<leader>ga", ":FzfLua lsp_code_actions<CR>", opts },
			{ "<leader>gh", ":FzfLua lsp_references<CR>", opts },
			{ "<leader>gd", ":FzfLua lsp_definitions<CR>", opts },
			{ "<leader>tt", ":FzfLua tabs<CR>", opts },
		},
		config = function()
			require("fzf-lua").setup({
				"ivy",
				lsp = {
					code_actions = {
						previewer = false,
					},
				},
			})

			require("fzf-lua").register_ui_select()
		end,
	},
}
