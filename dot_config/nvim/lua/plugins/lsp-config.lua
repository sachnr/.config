return {
	"neovim/nvim-lspconfig",
	config = function()
		local present, icons = pcall(require, "mini.icons")

		local diagnostic_signs = {}
		if present then
			diagnostic_signs = {
				[vim.diagnostic.severity.ERROR] = icons.get("lsp", "error"),
				[vim.diagnostic.severity.WARN] = icons.get("lsp", "warning"),
				[vim.diagnostic.severity.INFO] = icons.get("lsp", "info"),
				[vim.diagnostic.severity.HINT] = icons.get("lsp", "hint"),
			}
		else
			diagnostic_signs = {
				[vim.diagnostic.severity.ERROR] = "E",
				[vim.diagnostic.severity.WARN] = "W",
				[vim.diagnostic.severity.INFO] = "I",
				[vim.diagnostic.severity.HINT] = "H",
			}
		end

		vim.diagnostic.config({
			virtual_text = {
				source = true,
				prefix = "■",
				spacing = 2,
				severity = {
					min = vim.diagnostic.severity.ERROR,
				},
			},
			signs = {
				text = diagnostic_signs,
			},
			underline = {
				severity = {
					min = vim.diagnostic.severity.WARN,
				},
			},
			update_in_insert = false,
			severity_sort = true,
		})

		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--compile-commands-dir=.",
				"--cross-file-rename",
				"--header-insertion-decorators",
				"--header-insertion=iwyu",
			},
		})
		vim.lsp.set_log_level("ERROR")

		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
					analyses = {
						unusedparams = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		})

		vim.lsp.config("tsl_ls", {
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		})

		vim.lsp.enable({
			"bashls",
			"clangd",
			"cssls",
			"eslint",
			"glsl_analyzer",
			"golangci_lint_ls",
			"gopls",
			"html",
			"lua_ls",
			"nil_ls",
			"pyright",
			"rust_analyzer",
			"sqlls",
			"tailwindcss",
			"templ",
			"ts_ls",
			"vue_ls",
			"zls",
		})

		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { silent = true, desc = "LSP: diagnostic open" })
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1 })
		end, { silent = true, desc = "LSP: diagnostic goto prev" })
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, { silent = true, desc = "LSP: diagnostic goto next" })
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local mapbuf = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, silent = true, desc = "LSP: " .. desc })
				end

				mapbuf("\\", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, "Toggle Inlay Hints")

				mapbuf("gr", vim.lsp.buf.rename, "LSP Rename")
				mapbuf("K", vim.lsp.buf.hover, "Hover")
				mapbuf("gi", vim.lsp.buf.implementation, "Goto Implementation")
				mapbuf("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
				mapbuf("<leader>ld", vim.lsp.buf.type_definition, "Type Definition")
			end,
		})

		local ok, _ = pcall(require, "snacks")
		if ok then
			local progress = vim.defaulttable()
			vim.api.nvim_create_autocmd("LspProgress", {
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
					if not client or type(value) ~= "table" then
						return
					end
					local p = progress[client.id]

					for i = 1, #p + 1 do
						if i == #p + 1 or p[i].token == ev.data.params.token then
							p[i] = {
								token = ev.data.params.token,
								msg = ("[%3d%%] %s%s"):format(
									value.kind == "end" and 100 or value.percentage or 100,
									value.title or "",
									value.message and (" **%s**"):format(value.message) or ""
								),
								done = value.kind == "end",
							}
							break
						end
					end

					local msg = {} ---@type string[]
					progress[client.id] = vim.tbl_filter(function(v)
						return table.insert(msg, v.msg) or not v.done
					end, p)

					local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
					vim.notify(table.concat(msg, "\n"), "info", {
						id = "lsp_progress",
						title = client.name,
						opts = function(notif)
							notif.icon = #progress[client.id] == 0 and " "
								or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
						end,
					})
				end,
			})
		end
	end,
}
