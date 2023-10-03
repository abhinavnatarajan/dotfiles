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

function M.set_indent()
	vim.ui.select(
		{"Spaces", "Tabs"},
		{prompt = "Choose indent method"},
		function(indent_method)
			if indent_method then
				vim.ui.input(
					{prompt = "Set auto-indent width:"},
					function(input)
						local indent_w = tonumber(input)
						if indent_method == "Spaces" then
							vim.bo.expandtab = true
							vim.bo.tabstop = indent_w
							vim.bo.shiftwidth = 0
						elseif indent_method == "Tabs" then
							vim.bo.expandtab = false
							vim.bo.tabstop = indent_w
							vim.bo.shiftwidth = indent_w
						end
						M.silent_auto_indent()
					end
				)
			end
		end
	)
end

return M
