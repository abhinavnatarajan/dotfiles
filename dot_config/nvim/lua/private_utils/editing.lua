local M = {}

function M.silent_auto_indent()
	local winpos = vim.fn.winsaveview()
	vim.cmd [[silent exe "normal gg=G"]]
	vim.schedule(function() vim.fn.winrestview(winpos) end)
end

function M.remove_trailing_whitespace()
	local winpos = vim.fn.winsaveview()
	vim.cmd [[ silent %s/\v\s+$//e ]]
	vim.schedule(function() vim.fn.winrestview(winpos) end)
end

-- moves the cursor when toggling comments
function M.comment_in_insert_mode()
	local utils = require("Comment.utils")
	local ft = require("Comment.ft")
	local config = require("Comment.config"):get()
	local api = require("Comment.api")
	local ctx = {
		ctype = utils.ctype.linewise,
		range = utils.get_region() -- gets the current line region
	}
	local cstr = ft.calculate(ctx)
	local leftcstr, rightcstr = utils.unwrap_cstr(cstr)
	local is_commented = utils.is_commented(leftcstr, rightcstr, config.padding)(vim.api.nvim_get_current_line())
	api.toggle.linewise()
	local offset = #leftcstr
	if config.padding then
		offset = offset + 1
	end
	if is_commented then
		local leftkey = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
		vim.api.nvim_feedkeys(string.rep(leftkey, offset), "nt", false)
	else
		local rightkey = vim.api.nvim_replace_termcodes("<Riget>", true, false, true)
		vim.api.nvim_feedkeys(string.rep(rightkey, offset), "nt", false)
	end
end

function M.retab_leading_spaces()
	local winview = vim.fn.winsaveview()
	local ts = vim.bo.tabstop
	vim.cmd ([[ %s@\v^( {]] .. ts .. [[})+@\=repeat("\t", len(submatch(0))/]] .. ts .. [[)@]])
	vim.schedule(function() vim.fn.winrestview(winview) end)
end

function M.choose_buffer_indent()
	vim.ui.select(
		{"Spaces", "Tabs"},
		{prompt = "Choose indent method"},
		function(indent_method)
			if indent_method then
				vim.ui.input(
					{prompt = "Set auto-indent width:"},
					function(input)
						if input then
							local indent_w = tonumber(input)
							if indent_method == "Spaces" then
								vim.bo.expandtab = true
								vim.bo.tabstop = indent_w
								vim.bo.shiftwidth = 0
								vim.cmd[[ retab! ]]
							elseif indent_method == "Tabs" then
								vim.bo.expandtab = false
								vim.bo.tabstop = indent_w
								vim.bo.shiftwidth = indent_w
								M.retab_leading_spaces()
							end
						end
					end
				)
			end
		end
	)
end

function M.choose_global_indent()
	vim.ui.select(
		{"Spaces", "Tabs"},
		{prompt = "Choose indent method"},
		function(indent_method)
			if indent_method then
				vim.ui.input(
					{prompt = "Set auto-indent width:"},
					function(input)
						if input then
							local indent_w = tonumber(input)
							if indent_method == "Spaces" then
								vim.go.expandtab = true
								vim.go.tabstop = indent_w
								vim.go.shiftwidth = 0
							elseif indent_method == "Tabs" then
								vim.go.expandtab = false
								vim.go.tabstop = indent_w
								vim.go.shiftwidth = indent_w
							end
						end
					end
				)
			end
		end
	)
end

return M
