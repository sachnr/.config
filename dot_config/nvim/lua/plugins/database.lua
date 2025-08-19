return {
	-- "tpope/vim-dadbod",
	-- "kristijanhusak/vim-dadbod-ui",

	{
		"kndndrj/nvim-dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			-- Install tries to automatically detect the install method.
			-- if it fails, try calling it with one of these parameters:
			--    "curl", "wget", "bitsadmin", "go"
			require("dbee").install("go")
		end,
		config = function()
			local tools = require("dbee.layouts.tools")
			local api_ui = require("dbee.api.ui")

			local CustomLayout = {}
			CustomLayout.__index = CustomLayout

			function CustomLayout:new(opts)
				opts = opts or {}
				local o = {
					egg = nil,
					windows = {},
					drawer_width = opts.drawer_width or 40,
					result_height = opts.result_height or 15,
					is_opened = false,
				}
				setmetatable(o, self)
				return o
			end

			function CustomLayout:is_open()
				return self.is_opened
			end

			function CustomLayout:open()
				self.egg = tools.save()
				self.windows = {}

				tools.make_only(0)
				local editor_win = vim.api.nvim_get_current_win()
				self.windows["editor"] = editor_win
				api_ui.editor_show(editor_win)

				vim.cmd("to" .. self.drawer_width .. "vsplit")
				local drawer_win = vim.api.nvim_get_current_win()
				self.windows["drawer"] = drawer_win
				api_ui.drawer_show(drawer_win)

				vim.api.nvim_set_current_win(editor_win)
				vim.cmd("bo" .. self.result_height .. "split")
				local result_win = vim.api.nvim_get_current_win()
				self.windows["result"] = result_win
				api_ui.result_show(result_win)

				vim.api.nvim_set_current_win(editor_win)
				self.is_opened = true
			end

			function CustomLayout:close()
				for _, win in pairs(self.windows) do
					pcall(vim.api.nvim_win_close, win, false)
				end
				tools.restore(self.egg)
				self.egg = nil
				self.is_opened = false
			end

			function CustomLayout:reset()
				vim.api.nvim_win_set_height(self.windows["result"], self.result_height)
				vim.api.nvim_win_set_width(self.windows["drawer"], self.drawer_width)
			end

			require("dbee").setup({
				window_layout = CustomLayout:new({ drawer_width = 40, result_height = 20 }),
			})
		end,
	},
}
