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
		vim.notify(vim.inspect(res), vim.log.levels.INFO)
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

function M.aerial_winid()
	local aerial = require('aerial')
	local wins = M.list_wins()
	for i, v in ipairs(wins) do
		-- If aerial is open for any window then close it
		if v.filetype == 'aerial' then
			return v
		end
	end
	return nil
end

-- Function to toggle aerial with positioning compatible with nvimtree
function M.toggle_aerial()
	--  Check if aerial is already open
	local aerial = require('aerial')
	local aerial_winid = M.aerial_winid()
	if aerial_winid then
		aerial.close_all()
		return
	end
	-- If aerial is not open then we will open it
	-- Check if nvim-tree is open
	local nvt = require("nvim-tree.api").tree
	local nvt_winid = nvt.winid()
	if nvt_winid then
		local source_winid = vim.api.nvim_get_current_win()
		nvt.open()
		vim.cmd("split")
		local target_winid = vim.api.nvim_get_current_win()
		aerial.open_in_win(target_winid, source_winid)
	else
		aerial.open({focus = true, direction = 'right'})
	end
end

-- Function to toggle nvimtree with positioning compatible with aerial
function M.toggle_nvimtree()
	-- If NvimTree is open we close it
	local nvt = require("nvim-tree.api").tree
	local aerial = require('aerial')
	local aerial_winid = M.aerial_winid()
	if nvt.is_visible() or not aerial_winid then
		vim.cmd("silent NvimTreeToggle")
		return
	end

	aerial.focus()
	vim.cmd('aboveleft split')
	local nvt_winid = vim.api.nvim_get_current_win()
	nvt.open({winid = nvt_winid})
end

return M
