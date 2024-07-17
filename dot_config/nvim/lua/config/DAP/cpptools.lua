local M = {}
-- debug adapter configuration for cppdbg, which is the nvim-dap name for cpptools

M.setup = function()
	local dap = require('dap')
	local findProgFromProcID = function(cfg, on_config)
		cfg.program = vim.system({ 'readlink', '-f', '/proc/' .. cfg.processId .. '/exe' }, { text = true }):wait().stdout
		-- cfg.program = '/home/abhinav/mambaforge/envs/chalc/bin/python3.11'
		on_config(cfg)
	end

	local addArgs = function(cfg, on_config)
		cfg.args = vim.split(vim.fn.input('Arguments (separate with spaces): '), ' ')
		on_config(cfg)
	end
	-- adapter setup
	-- this function is run when debugging starts
	-- allows for dynamic adapter setup
	-- here we use it to change the adapter setup based on the debug request
	dap.adapters.cppdbg = function(callback, config)
		local adapter = {
			id = 'cppdbg',
			type = 'executable',
			command = vim.fn.exepath('OpenDebugAD7'),
			detached = vim.fn.has('win32') == 1 and false or true,
		}
		if config.name == 'Launch file with args' then
			adapter.enrich_config = addArgs
		end
		if config.request == 'attach' then
			adapter.enrich_config = findProgFromProcID
		end
		callback(adapter)
	end

	-- adapter configurations
	local osname = vim.uv.os_uname().sysname
	local debugger_name
	if osname == 'Darwin' then
		debugger_name = 'lldb'
	else
		debugger_name = 'gdb'
	end
	local config = {
		{
			name = "Launch file",
			type = "cppdbg",
			request = "launch",
			MIMode = debugger_name,
			program = '${command:pickFile}',
			cwd = '${workspaceFolder}',
			setupCommands = {
				{
					description = "Enable pretty-printing for gdb",
					text = "-enable-pretty-printing",
					ignoreFailures = true,
				},
			}
		},
		{
			name = "Launch file with args",
			type = "cppdbg",
			request = "launch",
			MIMode = debugger_name,
			program = '${command:pickFile}',
			cwd = '${workspaceFolder}',
			setupCommands = {
				{
					description = "Enable pretty-printing for gdb",
					text = "-enable-pretty-printing",
					ignoreFailures = true,
				},
			}
		},
		{
			name = "Attach to process",
			type = "cppdbg",
			request = "attach",
			MIMode = debugger_name,
			cwd = '${workspaceFolder}',
			processId = '${command:pickProcess}',
		}
	}
	for _, filetype in ipairs({ 'cpp', 'c', 'rust', 'asm', 'cuda', 'opencl', 'glsl', 'hlsl' }) do
		dap.configurations[filetype] = config
	end
end

return M
