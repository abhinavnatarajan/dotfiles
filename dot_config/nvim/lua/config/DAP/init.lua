local M = {}

M.setup = function()
	-- setup the debug UI elements
	vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticError', linehl = '', numhl = '' })
	vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = '', linehl = '', numhl = '' })
	vim.fn.sign_define('DapLogPoint', { text = '', texthl = '', linehl = '', numhl = '' })
	vim.fn.sign_define('DapStopped', { text = '→', texthl = 'DiagnosticWarn', linehl = 'DAPStoppedLine', numhl = '' })
	vim.fn.sign_define('DapBreakpointRejected', { text = '󰦎', texthl = '', linehl = '', numhl = '' })

	-- make sure Mason is loaded first
	require("mason")
	-- setup the debug adapters
	require("mason-nvim-dap")
end

return M
