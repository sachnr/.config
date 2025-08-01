return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			files = {
				cmd = "fd --type f --exec stat -c '%Y %n' {} + | sort -rn | cut -d' ' -f2-",
			},
			keymap = {
				fzf = {
					["ctrl-q"] = "select-all+accept",
				},
			},
		})

		local set = vim.keymap.set
		local common_opts = { silent = true, noremap = true }

		set("n", "<leader>tf", function()
			require("fzf-lua").files()
		end, common_opts)

		set("n", "<leader>to", function()
			require("fzf-lua").oldfiles()
		end, common_opts)

		set("n", "<leader>t/", function()
			require("fzf-lua").live_grep()
		end, common_opts)

		set("n", "<leader>tq", function()
			require("fzf-lua").quickfix()
		end, common_opts)

		set("n", "<leader>ts", function()
			require("fzf-lua").lsp_document_symbols()
		end, common_opts)

		set("n", "<leader>tg", function()
			require("fzf-lua").live_grep()
		end, common_opts)

		set("n", "gh", function()
			require("fzf-lua").lsp_references()
		end, vim.tbl_extend("force", common_opts, { nowait = true }))

		set("n", "gd", function()
			require("fzf-lua").lsp_definitions()
		end, vim.tbl_extend("force", common_opts, { nowait = true }))

		set("n", "<leader>tS", function()
			require("fzf-lua").lsp_workspace_symbols()
		end, common_opts)
	end,
}
