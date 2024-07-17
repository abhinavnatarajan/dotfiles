local M = {}

local getPythonPath = function()
	if os.getenv('VIRTUAL_ENV') then
		return os.getenv('VIRTUAL_ENV') .. '/bin/python'
	elseif os.getenv('CONDA_PREFIX') then
		return os.getenv('CONDA_PREFIX') .. '/bin/python'
	else
		local cwd = vim.fn.getcwd()
		if vim.fn.filereadable(cwd .. '/venv/bin/python') then
			return cwd .. '/venv/bin/python'
		elseif vim.fn.filereadable(cwd .. '/.venv/bin/python') then
			return cwd .. '/.venv/bin/python'
		elseif vim.fn.filereadable(cwd .. '/.env/bin/python') then
			return cwd .. '/.env/bin/python'
		elseif vim.fn.filereadable(cwd .. '/env/bin/python') then
			return cwd .. '/env/bin/python'
		elseif vim.fn.filereadable(cwd .. '/bin/python') then
			return cwd .. '/bin/python'
		else
			return vim.fn.exepath('python')
		end
	end
end

M.setup = function()
	local dap = require('dap')
	-- adapter setup
	dap.adapters.python = function(callback, config)
		-- this function is run when debugging starts
		-- allows for dynamic adapter setup
		-- here we use it to change the adapter setup based on the debug request
		if config.request == 'attach' then
			local port = (config.connect or config).port
			local host = (config.connect or config).host or '127.0.0.1'
			callback({
				type = 'server',
				port = assert(port, '`connect.port` is required for a python `attach` configuration'),
				host = host,
				options = {
					source_filetype = 'python',
				},
			})
		elseif config.request == 'launch' then
			callback({
				type = 'executable',
				command = vim.fn.exepath('debugpy-adapter'),
				-- This property is a function which allows an adapter
				-- to enrich a configuration with additional information.
				-- It receives a configuration as first argument,
				-- and a callback that must be called with the final configuration as second argument.
				options = {
					source_filetype = 'python',
				},
			})
		end
	end

	-- adapter configurations
	dap.configurations.python = {
		{
			-- Values for properties other than the 3 required properties `type`, `request`, and `name` can be functions.
			-- If a value is given as a function, the function will be evaluated
			-- to get the property value when the configuration is used.
			-- The first three options are required by nvim-dap

			type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = 'launch',
			name = "Python: Debug",

			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
			program = "${file}",         -- This configuration will launch the current file if used.
			console = "integratedTerminal", -- options are: internalConsole, integratedTerminal, externalTerminal
			-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
			python = getPythonPath,
			justMyCode = false,
		},
		{
			type = 'python',
			request = 'launch',
			name = "Python: Debug with args",

			program = "${file}",
			console = "integratedTerminal",
			python = getPythonPath,
			args = function()
				local argstr = vim.fn.input("Arguments: ")
				return vim.split(argstr, " +")
			end,
			justMyCode = false,
		},
		{
			type = 'python',
			request = 'attach',
			name = 'Attach remote',
			connect = function()
				local host = vim.fn.input({ prompt = 'Host', default = '127.0.0.1', cancelreturn = '127.0.0.1'})
				local port = tonumber(vim.fn.input({prompt = 'Port', default = '5678', cancelreturn = '5678'})) or 5678
				return { host = host, port = port }
			end,
		}
	}
end

return M
