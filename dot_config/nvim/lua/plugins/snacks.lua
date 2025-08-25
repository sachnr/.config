local opts = { silent = true, noremap = true }

return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	keys = {
		{ "<leader>tf", "<Cmd>lua Snacks.picker.files()<CR>", opts },
		{ "<leader>to", "<Cmd>lua Snacks.picker.recent()<CR>", opts },
		{ "<leader>t/", "<Cmd>lua Snacks.picker.lines()<CR>", opts },
		{ "<leader>tg", "<Cmd>lua Snacks.picker.grep()<CR>", opts },
		{ "<leader>tq", "<Cmd>lua Snacks.picker.qflist()<CR>", opts },
		{ "<leader>th", "<Cmd>lua Snacks.picker.lsp_symbols()<CR>", opts },
		{ "<leader>tb", "<Cmd>lua Snacks.picker.buffers()<CR>", opts },
		{ "gh", "<Cmd>lua Snacks.picker.lsp_references()<CR>", { nowait = true } },
		{ "gd", "<Cmd>lua Snacks.picker.lsp_definitions()<CR>", { desc = "Goto Definition" } },
		{ "gy", "<Cmd>lua Snacks.picker.lsp_type_definitions()<CR>", { desc = "Goto Definition" } },
		{ "<M-z>", "<Cmd>lua Snacks.zen()<CR>", opts },
		{ "<leader>gb", "<Cmd>lua Snacks.git.blame_line()<CR>", opts },
		{
			"<C-b>",
			function()
				local tab_count = vim.fn.tabpagenr("$")
				local current_tab = vim.fn.tabpagenr()

				if tab_count == 1 then
					vim.notify("Only one tab", vim.log.levels.WARN)
					return
				end

				if tab_count == 2 then
					vim.cmd("tabnext")
					return
				end

				local tabs = {}
				for i = 1, tab_count do
					local buflist = vim.fn.tabpagebuflist(i)
					local winnr = vim.fn.tabpagewinnr(i)
					local bufnr = buflist[winnr]
					local bufname = vim.fn.bufname(bufnr)
					local name = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"

					tabs[i] = {
						text = string.format("Tab %d: %s", i, name),
						tabpage = i,
						current = (i == current_tab),
					}
				end

				vim.ui.select(tabs, {
					prompt = "Select Tab:",
					format_item = function(item)
						return item.current and "• " .. item.text or "  " .. item.text
					end,
				}, function(choice)
					if choice then
						vim.cmd("tabnext " .. choice.tabpage)
					end
				end)
			end,
			mode = { "n", "t" },
			opts,
		},
	},
	config = function()
		local Snacks = require("snacks")
		Snacks.setup({
			image = { enabled = true },
			bigfile = { enabled = true },
			picker = {
				enabled = true,
				layout = "ivy",
				matcher = {
					frecency = true, -- frecency bonus
				},
				ui_select = true,
				buffers = {},
			},
			zen = { enabled = true, toggles = {
				dim = false,
			} },
			git = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			notify = { enabled = true },
		})
		vim.notify = Snacks.notifier.notify
	end,
}
