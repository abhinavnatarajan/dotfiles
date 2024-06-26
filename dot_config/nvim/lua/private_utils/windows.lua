local M = {}

function M.filter(_, bufid)
	return vim.api.nvim_get_option_value("filetype", { buf = bufid }) == "alpha"
			or not M.exclude_buftypes[vim.api.nvim_get_option_value("buftype", { buf = bufid })]
	-- return vim.api.nvim_buf_get_option(bufid, 'filetype') == "alpha" or not M.exclude_buftypes[vim.api.nvim_buf_get_option(bufid, 'buftype')]
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
			buftype = vim.api.nvim_get_option_value("buftype", { buf = buf }),
			filetype = vim.api.nvim_get_option_value("filetype", { buf = buf }),
		}
	end, vim.api.nvim_tabpage_list_wins(0))
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

-- If aerial is open then return its window id
function M.aerial_is_open()
	local wins = M.list_wins()
	for _, v in ipairs(wins) do
		if v.filetype == "aerial" then
			return v
		end
	end
	return nil
end

function M.get_window_handle(window_number)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_number(win) == window_number then
			return win
		end
	end
	return nil
end

-- Function to toggle aerial with positioning compatible with nvimtree
function M.toggle_aerial()
	--  Check if aerial is already open
	local aerial = require("aerial")
	if M.aerial_is_open() then
		aerial.close_all()
		return
	end
	-- If aerial is not open then we will open it
	-- Check if nvim-tree is open
	local nvt = require("nvim-tree.api").tree
	if nvt.winid() then
		local source_winid = vim.api.nvim_get_current_win()
		nvt.open()
		vim.cmd("split")
		local target_winid = vim.api.nvim_get_current_win()
		aerial.open_in_win(target_winid, source_winid)
	else
		aerial.open({ focus = true, direction = "right" })
	end
end

-- Function to toggle nvimtree with positioning compatible with aerial
function M.toggle_nvimtree()
	local nvt = require("nvim-tree.api").tree
	local aerial_win = M.aerial_is_open()
	if not aerial_win or nvt.is_visible() then
		nvt.toggle()
		return
	end

	-- if aerial is open then we split its window
	local nvt_target_win = vim.api.nvim_open_win(0, false, {
		win = aerial_win.winnr,
		style = "minimal",
		split = 'above',
	})
	nvt.toggle({ winid = nvt_target_win })
end

-- Function to toggle nvimtree with positioning compatible with aerial
function M.focus_file_in_nvim_tree()
	local nvt = require("nvim-tree.api").tree
	local aerial_win = M.aerial_is_open()
	if not aerial_win or nvt.is_visible() then
		nvt.open({ find_file = true })
		return
	end

	-- if aerial is open then we split its window
	local nvt_target_win = vim.api.nvim_open_win(0, false, {
		win = aerial_win.winnr,
		style = "minimal",
		split = 'above',
	})
	nvt.open({ find_file = true, winid = nvt_target_win })
end
return M
