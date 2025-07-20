---@diagnostic disable: inject-field, need-check-nil
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"nvim-lua/plenary.nvim",
				"mrcjkb/rustaceanvim",
				"folke/neodev.nvim",
			},
		},

		config = function()
			local helper = require("helper")
			local lspconfig = require("lspconfig")
			local icons = require("icons").diagnostics
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			vim.filetype.add({ extension = { templ = "templ" } })

			local on_attach_common = function(client, buffer)
				client.server_capabilities.semanticTokensProvider = nil
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
				helper.lsp_attach(buffer)
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

				float = {
					source = true,
					border = "single",
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.error,
						[vim.diagnostic.severity.WARN] = icons.warn,
						[vim.diagnostic.severity.HINT] = icons.hint,
						[vim.diagnostic.severity.INFO] = icons.info,
					},
				},
				-- signs = true,
				underline = {
					severity = {
						min = vim.diagnostic.severity.WARN,
					},
				},
				update_in_insert = false,
				severity_sort = true,
			})

			local servers = {
				"html",
				"glsl_analyzer",
				"wgsl_analyzer",
				"bashls",
				"jsonls",
				"cssls",
				-- "pylsp",
				"yamlls",
				"nil_ls",
				"ocamllsp",
				"templ",
			}

			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach_common,
					capabilities = capabilities,
				})
			end

			require("neodev").setup({
				override = function(root_dir, library)
					if root_dir:find("/etc/nixos", 1, true) == 1 then
						library.enabled = true
						library.plugins = true
					end
				end,
			})

			lspconfig.lua_ls.setup({
				on_attach = function(client, buffer)
					on_attach_common(client, buffer)
				end,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						telemetry = { enable = false },
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})

			lspconfig.clangd.setup({
				filetypes = { "c", "cpp", "objc", "objcpp" },
				cmd = {
					"clangd",
					"--clang-tidy",
					"--compile-commands-dir=.",
					"--cross-file-rename",
					"--header-insertion-decorators",
					"--header-insertion=iwyu",
				},
				on_attach = on_attach_common,
				capabilities = capabilities,
			})

			lspconfig.gopls.setup({
				on_attach = function(client, buffer)
					on_attach_common(client, buffer)
				end,
				capabilities = capabilities,
				filetypes = { "go", "gomod", "gowork", "gotmpl", "tmpl" },
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

			lspconfig.qmlls.setup({
				cmd = { "qmlls", "-E" },
				on_attach = function(_, buffer)
					helper.lsp_attach(buffer)
				end,
				capabilities = capabilities,
			})

			vim.g.rustaceanvim = function()
				return {
					server = {
						on_attach = function(client, bufnr)
							on_attach_common(client, bufnr)
							helper.lsp_attach(bufnr)
						end,
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								procMacro = {
									enable = true,
									ignored = {
										leptos_macro = {
											-- optional: --
											-- "component",
											"server",
										},
									},
								},
								experimental = { procAttrMacros = true },
								checkOnSave = { command = "clippy" },
								inlayHints = {
									lifetimeElisionHints = { enable = true, useParameterNames = true },
								},
							},
						},
					},
				}
			end

			local util = require("lspconfig.util")

			local function get_typescript_server_path(root_dir)
				local global_ts = "/home/" .. os.getenv("USER") .. "/.config/yarn/global/node_modules/typescript/lib"
				-- Alternative location if installed as root:
				-- local global_ts = '/usr/local/lib/node_modules/typescript/lib'
				local found_ts = ""
				local function check_dir(path)
					found_ts = util.path.join(path, "node_modules", "typescript", "lib")
					if util.path.exists(found_ts) then
						return path
					end
				end
				if util.search_ancestors(root_dir, check_dir) then
					return found_ts
				else
					return global_ts
				end
			end

			lspconfig.volar.setup({
				filetypes = { "vue" },
				init_options = {
					vue = {
						hybridMode = false,
					},
					typescript = {
						tsdk = get_typescript_server_path(vim.fn.getcwd()),
					},
				},
			})

			lspconfig.ts_ls.setup({
				on_attach = function(client, bufnr)
					on_attach_common(client, bufnr)
				end,
				init_options = {
					plugins = {
						-- {
						-- 	name = "@vue/typescript-plugin",
						-- 	location = "/home/"
						-- 		.. os.getenv("USER")
						-- 		.. "/.config/yarn/global/node_modules/@vue/typescript-plugin",
						-- 	languages = { "javascript", "typescript", "vue" },
						-- },
					},
				},
				capabilities = capabilities,
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
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			})

			lspconfig.pyright.setup({
				on_attach = function(client, bufnr)
					on_attach_common(client, bufnr)
				end,
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
						},
					},
				},
			})

			lspconfig.htmx.setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					helper.lsp_attach(bufnr)
				end,
				capabilities = capabilities,
				filetypes = { "html", "templ" },
			})

			lspconfig.html.setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					helper.lsp_attach(bufnr)
				end,
				capabilities = capabilities,
				filetypes = { "html", "templ" },
			})

			-- lspconfig.tailwindcss.setup({
			-- 	on_attach = function(client, buffer)
			-- 		client.server_capabilities.documentFormattingProvider = false
			-- 		client.server_capabilities.documentRangeFormattingProvider = false
			-- 		lsp_attach(buffer)
			-- 	end,
			-- 	capabilities = capabilities,
			-- })

			lspconfig.zls.setup({
				on_attach = function(client, bufnr)
					on_attach_common(client, bufnr)
				end,
				capabilities = capabilities,
			})

			local autocmd = vim.api.nvim_create_autocmd
			autocmd("FileType", {
				pattern = "liquid",
				callback = function()
					local root_dir = vim.fs.dirname(vim.fs.find({ ".theme-check.yml" }, { upward = true })[1])
					local client = vim.lsp.start({
						on_attach = function(_, bufnr)
							helper.lsp_attach(bufnr)
						end,
						capabilities = capabilities,
						name = "shopify_ls",
						cmd = { "shopify", "theme", "language-server" },
						root_dir = root_dir,
					})
					if client then
						vim.lsp.buf_attach_client(vim.api.nvim_get_current_buf(), client)
					end
				end,
			})
		end,
	},
}
