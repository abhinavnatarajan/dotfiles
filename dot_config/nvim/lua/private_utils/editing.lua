local M = {}

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
	vim[scope].tabstop = indent_width    -- number of spaces that a <Tab> in the file counts for
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
		-- compute current indent string in case we need to reindent
		local old_indent_width = buffer_local and vim.bo.tabstop or vim.o.tabstop
		local old_is_spaces = buffer_local and vim.bo.expandtab or vim.o.expandtab
		local old_indent_string = old_is_spaces and string.rep(" ", old_indent_width) or "\t"
		-- get new indent settings
		local indent_type = utils.async_get_selection({ "Tabs", "Spaces" }, { prompt = "Choose indent method: " })
		if not indent_type then
			return
		end
		local indent_width_string = utils.async_get_input({ prompt = "Choose indent width: " })
		if not indent_width_string then
			return
		end
		local indent_width = tonumber(indent_width_string)
		if not indent_width then
			vim.notify("Invalid indent width", vim.log.levels.ERROR)
			return
		end
		set_indent_type(indent_type, buffer_local)
		set_indent_width(indent_width, buffer_local)
		-- compute new indent string
		local new_is_spaces = indent_type == "Spaces"
		local new_indent_string = new_is_spaces and string.rep(" ", indent_width) or "\t"
		if old_indent_string ~= new_indent_string then
			M.reindent(old_indent_string, new_indent_string)
		end
	end)()
end

-- this function can mess up indentation if converting from spaces to tabs
-- because when using spaces there is no way to distinguish between
-- indentation and alignment spaces
function M.reindent(old_indent_string, new_indent_string)
	local winview = vim.fn.winsaveview()
	local search_pattern = string.format([[^\(%s\)*]], old_indent_string)
	local re = vim.regex(search_pattern)
	for i, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, true)) do
		local _, indent_len = re:match_str(line)
		local repetitions = 0
		if indent_len then
			repetitions = indent_len / #old_indent_string
		end
		local new_line = string.rep(new_indent_string, repetitions) .. line:sub(indent_len + 1, -1)
		vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
	end
	vim.schedule(function()
		vim.fn.winrestview(winview)
	end)
end

function M.choose_file_newline()
	local icons = require("icons")
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

return M
