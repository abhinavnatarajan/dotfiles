local M = {}

M.ensure_installed = {
	"debugpy",
	"cpptools",
}

M.setup = function()
	-- setup the debug UI elements
	local icons = require('icons')
	vim.fn.sign_define('DapBreakpoint', { text = icons.debug.Breakpoint, texthl = 'DiagnosticError', linehl = '', numhl = '' })
	vim.fn.sign_define('DapBreakpointCondition', { text = icons.debug.BreakpointConditional, texthl = '', linehl = '', numhl = '' })
	vim.fn.sign_define('DapLogPoint', { text = icons.debug.LogPoint, texthl = '', linehl = '', numhl = '' })
	vim.fn.sign_define('DapStopped', { text = icons.debug.Stopped, texthl = 'DiagnosticWarn', linehl = 'DAPStoppedLine', numhl = '' })
	vim.fn.sign_define('DapBreakpointRejected', { text = icons.debug.BreakpointRejected, texthl = '', linehl = '', numhl = '' })

	for _, adapter_name in ipairs(M.ensure_installed) do
		require('config.DAP.' .. adapter_name).setup()
	end
end

return M
