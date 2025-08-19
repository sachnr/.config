local opts = { silent = true, noremap = true }

return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	keys = {
		{
			"<leader>tf",
			function()
				require("snacks.picker").files()
			end,
			opts,
		},
		{
			"<leader>to",
			function()
				require("snacks.picker").recent()
			end,
			opts,
		},
		{
			"<leader>t/",
			function()
				require("snacks.picker").lines()
			end,
			opts,
		},
		{
			"<leader>tg",
			function()
				require("snacks.picker").grep()
			end,
			opts,
		},
		{
			"<leader>tq",
			function()
				require("snacks.picker").qflist()
			end,
			opts,
		},
		{
			"<leader>tt",
			function()
				local tabs = {}
				for i = 1, vim.fn.tabpagenr("$") do
					local buflist = vim.fn.tabpagebuflist(i)
					local winnr = vim.fn.tabpagewinnr(i)
					local bufnr = buflist[winnr]
					local bufname = vim.fn.bufname(bufnr)
					local name = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
					table.insert(tabs, {
						text = string.format("Tab %d: %s", i, name),
						tabpage = i,
						current = i == vim.fn.tabpagenr(),
					})
				end

				vim.ui.select(tabs, {
					prompt = "Select Tab:",
					format_item = function(item)
						return item.current and item.text .. " (current)" or item.text
					end,
				}, function(choice)
					if choice then
						vim.cmd("tabnext " .. choice.tabpage)
					end
				end)
			end,
			opts,
		},
		{
			"<leader>th",
			function()
				require("snacks.picker").lsp_symbols()
			end,
			opts,
		},
		{
			"gh",
			function()
				require("snacks.picker").lsp_references()
			end,
			{ nowait = true },
		},
		{
			"gd",
			function()
				require("snacks.picker").lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gy",
			function()
				require("snacks.picker").lsp_type_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"<M-z>",
			function()
				require("snacks").zen()
			end,
			opts,
		},
		{
			"<leader>gb",
			function()
				require("snacks.git").blame_line()
			end,
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
					frecency = false, -- frecency bonus
				},
				ui_select = true,
			},
			zen = { enabled = true, toggles = {
				dim = false,
			} },
			rename = { enabled = true },
			git = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
		})
		vim.notify = Snacks.notifier.notify
	end,
}
