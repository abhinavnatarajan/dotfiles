local M = {}
local icons = require("icons")

function M.silent_auto_indent()
	local winpos = vim.fn.winsaveview()
	vim.cmd([[silent exe "lockmarks normal gg=G"]])
	vim.schedule(function()
		vim.fn.winrestview(winpos)
	end)
end

function M.remove_trailing_whitespace()
	local winpos = vim.fn.winsaveview()
	vim.cmd([[ keepjumps silent %s/\v\s+$//e | noh ]])
	vim.schedule(function()
		vim.fn.winrestview(winpos)
	end)
end

local set_indent_width = function(indent_width, buffer)
	buffer = buffer or false
	local scope = "go"
	if buffer then
		scope = "bo"
	end
	vim[scope].softtabstop = indent_width -- spaces that Tab counts for during editing. 0 means fallback to shiftwidth
	vim[scope].shiftwidth = indent_width -- number of spaces for indentation. 0 means fallback to tabstop.
	vim[scope].tabstop = indent_width -- number of spaces that a <Tab> in the file counts for
end

local set_indent_type = function(type, buffer)
	buffer = buffer or false
	local scope = "go"
	if buffer then
		scope = "bo"
	end
	if type == "Spaces" then
		vim[scope].expandtab = true
		return
	end
	if type == "Tabs" then
		vim[scope].expandtab = false
		return
	end
	assert(false, "Invalid indent type")
end

M.select_indent = function(buffer_local)
	buffer_local = buffer_local or false
	local utils = require("utils")
	coroutine.wrap(function()
		local indent_type = utils.async_get_selection({ "Tabs", "Spaces" }, { prompt = "Choose indent method: " })
		if not indent_type then
			return
		end
		set_indent_type(indent_type, buffer_local)
		local indent_width = utils.async_get_input({ prompt = "Choose indent width: " })
		if not indent_width then
			return
		end
		set_indent_width(tonumber(indent_width), buffer_local)
	end)()
end

function M.choose_file_newline()
	local options = {
		[icons.ui.Unix .. " unix"] = "unix",
		[icons.ui.Windows .. " windows"] = "dos",
		[icons.ui.MacOS .. " macOS"] = "mac",
	}
	local display_options = {}
	for k, _ in pairs(options) do
		table.insert(display_options, k)
	end
	vim.ui.select(display_options, { prompt = "Choose newline format" }, function(opt)
		if opt then
			vim.bo.fileformat = options[opt]
		end
	end)
end

function M.retab_leading_spaces(old_tabstop)
	local winview = vim.fn.winsaveview()
	vim.cmd(
		[[ silent %s@\v^(\s{]]
		.. old_tabstop
		.. [[})+@\=repeat("\t", len(submatch(0))/]]
		.. old_tabstop
		.. [[)@ | noh ]]
	)
	vim.schedule(function()
		vim.fn.winrestview(winview)
	end)
end

return M
