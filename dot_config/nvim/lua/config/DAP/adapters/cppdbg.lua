local M = {}
-- debug adapter configuration for cppdbg, which is the nvim-dap name for cpptools

---Dynamically setup the adapter and configurations when neovim starts.
---@param dap_config.name string the name of the adapter
---@param dap_config.adapters table a table containing the adapter setup (should really be adapter, not adapters)
---@param dap_config.configurations table a table containing the configurations for the adapter
---@param dap_config.filetypes table a table containing the filetypes supported by the adapter
M.handler = function(dap_config)
	local pickProcess = function(cfg, on_config)
		-- cfg.program = vim.system({'readlink', '-f', '/proc/' .. cfg.processId .. '/exe'}, { text = true }):wait().stdout
		cfg.program = '/home/abhinav/mambaforge/envs/chalc/bin/python3.11'
		on_config(cfg)
	end

	-- adapter setup
	-- this function is run when debugging starts
	-- allows for dynamic adapter setup
	-- here we use it to change the adapter setup based on the debug request
	dap_config.adapters = function(callback, config)
		local adapter = {
			id = 'cppdbg',
			type = 'executable',
			command = vim.fn.exepath('OpenDebugAD7'),
			detached = vim.fn.has('win32') == 1 and false or true,
		}
		if config.request == 'attach' then
			adapter.enrich_config = pickProcess
		end
		callback(adapter)
	end

	-- adapter configurations
	dap_config.configurations = {
		{
			name = "Launch file",
			type = "cppdbg",
			request = "launch",
			program = '${command:pickFile}',
			cwd = '${workspaceFolder}',
		},
		{
			name = "Attach to process",
			type = "cppdbg",
			request = "attach",
			cwd = '${workspaceFolder}',
			processId = '${command:pickProcess}',
		}
	}

	-- setup the new adapter and configuration
	require("mason-nvim-dap").default_setup(dap_config)
end

return M
