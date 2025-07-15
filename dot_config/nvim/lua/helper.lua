local m = {}

local set = vim.keymap.set
local opts = {
	silent = true,
	noremap = true,
}

local merge = function(table1, table2)
	return vim.tbl_deep_extend("force", table1, table2)
end

m.lsp_attach = function(bufnr)
	set("n", "<space>e", vim.diagnostic.open_float, merge(opts, { desc = "diagnostic float" }))
	set("n", "[d", vim.diagnostic.goto_prev, merge(opts, { desc = "diagnostic goto prev" }))
	set("n", "]d", vim.diagnostic.goto_next, merge(opts, { desc = "diagnostic goto next" }))
	-- set("n", "<leader>lq", vim.diagnostic.setloclist, merge(opts, { desc = "diagnostic setlocklist" }))
	local lsp_opts = merge(opts, { buffer = bufnr })
	set("n", "ga", vim.lsp.buf.code_action, merge(lsp_opts, { desc = "code_action" }))
	-- set("n", "ga", "<cmd> FzfLua lsp_code_actions <cr>", merge(lsp_opts, { desc = "code_action" }))
	set("n", "gh", vim.lsp.buf.references, merge(lsp_opts, { desc = "goto references" }))
	set("n", "gr", vim.lsp.buf.rename, merge(lsp_opts, { desc = "lsp rename" }))
	set("n", "K", vim.lsp.buf.hover, merge(lsp_opts, { desc = "hover" }))
	set("n", "gD", vim.lsp.buf.declaration, merge(lsp_opts, { desc = "goto declaration" }))
	set("n", "gd", vim.lsp.buf.definition, merge(lsp_opts, { desc = "goto definition" }))
	set("n", "gi", vim.lsp.buf.implementation, merge(lsp_opts, { desc = "goto implementation" }))
	set("n", "<C-k>", vim.lsp.buf.signature_help, merge(lsp_opts, { desc = "signature_help" }))
	set("n", "<leader>ld", vim.lsp.buf.type_definition, merge(lsp_opts, { desc = "Type Definition" }))
end

return m
