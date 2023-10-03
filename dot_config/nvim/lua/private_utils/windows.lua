local M = {}

function M.filter(winid, bufid)
		return vim.api.nvim_buf_get_option(bufid, 'filetype') == "alpha" or not M.exclude_buftypes[vim.api.nvim_buf_get_option(bufid, 'buftype')]
end

M.exclude_buftypes = {
	help = true,
	terminal = true,
	nofile = true,
}


function M.list_wins(silent)
	silent = silent or true
	local res = vim.tbl_map(function(win)
		local buf = vim.api.nvim_win_get_buf(win)
		return {
			winnr = win,
			bufnr = buf,
			buftype = vim.api.nvim_buf_get_option(buf, 'buftype'),
			filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
		}
	end,
		vim.api.nvim_tabpage_list_wins(0)
	)
	if not silent then
		vim.notify(vim.inspect(silent), vim.log.levels.INFO)
	end
	return res
end

-- how to open a new file for editing
function M.edit_new_file_handler()
	local win = M.get_window()
	vim.api.nvim_set_current_win(win)
	vim.cmd("enew")
end

-- how to open a file for editing
function M.get_window()
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(0)
	-- if current window is suitable then use it
	if M.filter(win, buf) then
		return win
	else
		-- else choose an existing window
		win = require("winpick").select()
		if win then
			return win
		else
			-- if no existing window is suitable then split the current window
			return M.new_window()
		end
	end
end

function M.new_window()
	vim.cmd("split")
	return vim.api.nvim_get_current_win()
end


return M
