local M = {}

function M.setup()
	local icons = require("icons")
	local signs = {
		"Breakpoint",
		"BreakpointCondition",
		"LogPoint",
		"Stopped",
		"BreakpointRejected",
	}
	for _, val in pairs(signs) do
		local hl = "Dap" .. val
		vim.fn.sign_define(hl, { text = icons.debug[val], texthl = hl, numhl = hl })
	end
	require("dap")
	require("dap.ext.vscode").json_decode = require("overseer.json").decode
  require('dap-python').setup('~/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
	require("dapui").setup{

	}
end

return M
