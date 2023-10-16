local function replace_qf_with_trouble()
	local ok, trouble = pcall(require, "trouble")
	if ok then
		-- Check whether we deal with a quickfix or location list buffer, close the window and open the
		-- corresponding Trouble.nvim window instead.
		if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
			vim.schedule(function()
				vim.cmd.lclose()
				trouble.open("loclist")
			end)
		else
			vim.schedule(function()
				vim.cmd.cclose()
				trouble.open("quickfix")
			end)
		end
	end
end

replace_qf_with_trouble()
