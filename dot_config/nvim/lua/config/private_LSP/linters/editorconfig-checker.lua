local M = {}

M.handler = function()
	local null_ls = require("null-ls")
	local editorconfigchecker = null_ls.builtins.diagnostics['editorconfig-checker'].with({
    disabled_filetypes = { "NvimTree" },
	})
	null_ls.register(editorconfigchecker)
end

return M
