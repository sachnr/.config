local MiniIcons = require("mini.icons")

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
			[vim.diagnostic.severity.ERROR] = MiniIcons.get("lsp", "error"),
			[vim.diagnostic.severity.WARN] = MiniIcons.get("lsp", "warning"),
			[vim.diagnostic.severity.INFO] = MiniIcons.get("lsp", "info"),
			[vim.diagnostic.severity.HINT] = MiniIcons.get("lsp", "hint"),
		},
	},
	underline = {
		severity = {
			min = vim.diagnostic.severity.WARN,
		},
	},
	update_in_insert = false,
	severity_sort = true,
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { silent = true, desc = "LSP: diagnostic open" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { silent = true, desc = "LSP: diagnostic goto prev" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { silent = true, desc = "LSP: diagnostic goto next" })

vim.api.nvim_create_user_command("LspRestart", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	local client_names = {}

	for _, client in ipairs(clients) do
		table.insert(client_names, client.name)
	end

	if #client_names > 0 then
		vim.lsp.enable(client_names, false)
		vim.lsp.enable(client_names, true)
	end
end, { desc = "Restart all LSP clients for current buffer" })

vim.cmd("set completeopt+=noselect")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local mapbuf = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, silent = true, desc = "LSP: " .. desc })
		end

		mapbuf("gr", vim.lsp.buf.rename, "LSP Rename")
		mapbuf("K", vim.lsp.buf.hover, "Hover")
		mapbuf("gi", vim.lsp.buf.implementation, "Goto Implementation")
		mapbuf("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
		mapbuf("<leader>ld", vim.lsp.buf.type_definition, "Type Definition")

		-- local client = vim.lsp.get_client_by_id(event.data.client_id)
		--
		-- if client:supports_method("textDocument/completion") then
		-- 	vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
		-- end
	end,
})
