local ok, cmp = pcall(require, "cmp")
if not ok then
	return
end

cmp.setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
