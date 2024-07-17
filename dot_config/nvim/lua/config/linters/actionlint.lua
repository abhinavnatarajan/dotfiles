return {
	setup = function()
		local null_ls = require("null-ls")
		local actionlint = null_ls.builtins.diagnostics.actionlint
		null_ls.register(actionlint)
	end
}
