local M = {}

M.handler = function()
	local null_ls = require("null-ls")
	local vale = null_ls.builtins.diagnostics.vale.with({
		diagnostics_postprocess = function(diagnostic)
			diagnostic.severity = vim.diagnostic.severity.HINT
		end
	})
	null_ls.register(vale)
end

return M
