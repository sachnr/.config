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
	"htmx",
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

local map = function(keys, func, desc)
	vim.keymap.set("n", keys, func, { silent = true, desc = "LSP: " .. desc })
end
local prev_diagnostic = function()
	vim.diagnostic.jump({ count = -1 })
end
local next_diagnostic = function()
	vim.diagnostic.jump({ count = 1 })
end

map("<leader>e", vim.diagnostic.open_float, "diagnostic open")
map("[d", prev_diagnostic, "diagnostic goto prev")
map("]d", next_diagnostic, "diagnostic goto next")

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

		local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = event.buf,
			group = highlight_augroup,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = event.buf,
			group = highlight_augroup,
			callback = vim.lsp.buf.clear_references,
		})

		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
			callback = function(event2)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
			end,
		})

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
		end
	end,
})

local progress = vim.defaulttable()

vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local value = event.data.params.value
		if not client or type(value) ~= "table" then
			return
		end
		local p = progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == event.data.params.token then
				p[i] = {
					token = event.data.params.token,
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
		vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
			id = "lsp_progress",
			title = client.name,
			opts = function(notif)
				notif.icon = #progress[client.id] == 0 and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})
