local M = {}

M.handler = function()
	local null_ls = require("null-ls")
	local codespell = null_ls.builtins.diagnostics.codespell.with({
    disabled_filetypes = { "NvimTree", "tex", "bib" },
	})
	null_ls.register(codespell)
end

return M
