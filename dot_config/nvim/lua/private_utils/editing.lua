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

function M.choose_buffer_indent()
	vim.ui.select({ "Spaces", "Tabs" }, { prompt = "Choose indent method" }, function(indent_method)
		if indent_method then
			vim.ui.input({ prompt = "Set auto-indent width:" }, function(input)
				if input then
					local indent_w = tonumber(input)
					if indent_method == "Spaces" then
						vim.bo.expandtab = true
						vim.bo.tabstop = indent_w
						vim.bo.shiftwidth = 0
						vim.cmd([[ retab! ]])
					elseif indent_method == "Tabs" then
						local old_tabstop = vim.bo.tabstop
						vim.bo.expandtab = false
						vim.bo.tabstop = indent_w
						vim.bo.shiftwidth = indent_w
						M.retab_leading_spaces(old_tabstop)
					end
				end
			end)
		end
	end)
end

function M.choose_global_indent()
	vim.ui.select({ "Spaces", "Tabs" }, { prompt = "Choose indent method" }, function(indent_method)
		if indent_method then
			vim.ui.input({ prompt = "Set auto-indent width:" }, function(input)
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
			end)
		end
	end)
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
