local helper = require("helper")

return {
	"luckasRanarison/tailwind-tools.nvim",
	name = "tailwind-tools",
	build = ":UpdateRemotePlugins",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim", -- optional
		"neovim/nvim-lspconfig", -- optional
	},
	opts = {
		server = {
			override = true, -- setup the server from the plugin if true
			settings = { -- shortcut for settings.tailwindCSS
				-- experimental = {
				--   classRegex = { "tw\\('([^']*)'\\)" }
				-- },
				includeLanguages = {
					templ = "html",
				},
			},
			filetypes = {
				"templ",
				"vue",
				"html",
				"astro",
				"javascript",
				"typescript",
				"react",
				"htmlangular",
			},
			on_attach = function(_, bufnr)
				helper.lsp_attach(bufnr)
			end,
			root_dir = function(fname)
				local lspconfig = require("lspconfig")
				local root_files = lspconfig.util.insert_package_json({
					"tailwind.config.{js,cjs,mjs,ts}",
					"assets/tailwind.config.{js,cjs,mjs,ts}",
					"theme/static_src/tailwind.config.{js,cjs,mjs,ts}",
					"app/assets/stylesheets/application.tailwind.css",
					"app/assets/tailwind/application.css",
					"assets/css/tailwind.css",
				}, "tailwindcss", fname)
				return lspconfig.util.root_pattern(root_files)(fname)
			end,
		},
	},
}
