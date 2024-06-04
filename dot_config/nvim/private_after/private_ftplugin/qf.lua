local qfclosecmd = ""
if vim.fn.getwininfo(vim.fn.win_getid())[1]["loclist"]==1 then
	qfclosecmd = "lclose"
else
	qfclosecmd = "cclose"
end
vim.schedule(function()
	vim.cmd(qfclosecmd)
	vim.cmd[[Trouble qflist open]]
end)
