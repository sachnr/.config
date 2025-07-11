return {
	{
		"stevearc/conform.nvim",
		keys = { {
			"<leader>f",
			function()
				require("conform").format({})
			end,
			desc = "Format",
		} },
		config = function()
			require("conform").setup({
				formatters = {
					leptosfmt = {
						command = "leptosfmt",
						args = { "--stdin", "--rustfmt", "$FILENAME" },
						stdin = true,
					},
					wgslfmt = {
						command = "wgslfmt",
						args = { "$FILENAME" },
						stdin = false,
					},
					norgfmt = {
						command = "norg-fmt",
						args = { "$FILENAME" },
						stdin = false,
					},
					ocamlformat = {
						prepend_args = {
							"--if-then-else",
							"vertical",
							"--break-cases",
							"fit-or-vertical",
							"--type-decl",
							"sparse",
						},
					},
					["clang-format"] = {
						prepend_args = {
							"--style",
							"{ IndentWidth: 4, SortIncludes: false, PointerAlignment: Left, BreakBeforeBraces: Custom, BraceWrapping: { AfterFunction: true, AfterControlStatement: false } , IndentCaseLabels: false, ReflowComments: false, ColumnLimit: 120, AccessModifierOffset: -4, AlignTrailingComments: true, AllowShortBlocksOnASingleLine: false, AllowShortIfStatementsOnASingleLine: false, AllowShortLoopsOnASingleLine: false }",
						},
					},
				},
				formatters_by_ft = {
					c = { "clang-format" },
					cpp = { "clang-format" },
					css = { "prettierd", "prettier", stop_after_first = true },
					go = { "gofmt" },
					html = { "prettierd", "prettier", stop_after_first = true },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					json = { "prettierd", "prettier", stop_after_first = true },
					jsonc = { "prettierd", "prettier", stop_after_first = true },
					liquid = { "prettierd", "prettier", stop_after_first = true },
					lua = { "stylua" },
					markdown = { "prettierd", "prettier", stop_after_first = true },
					nix = { "nixfmt" },
					norg = { "norgfmt" },
					ocaml = { "ocamlformat" },
					python = { "black" },
					rust = { "leptosfmt", "rustfmt", stop_after_first = true },
					scss = { "prettierd", "prettier", stop_after_first = true },
					sh = { "shfmt" },
					sql = { "pg_format" },
					toml = { "taplo" },
					template = { "prettierd", "prettier", stop_after_first = true },
					templ = { "templ" },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					vue = { "prettierd", "prettier", stop_after_first = true },
					yaml = { "prettierd", "prettier", stop_after_first = true },
					zig = { "zigfmt" },
				},
			})

			vim.api.nvim_create_user_command("FormatJsonSelection", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_fallback = true, range = range })
			end, { range = true })
		end,
	},
}
