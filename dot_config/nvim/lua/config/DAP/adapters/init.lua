local M = {}

M.ensure_installed = {
	"python", -- debugpy
	"cppdbg", -- cpptools
}

-- accepts nvim-dap adapter names
local get = function(adapter_name)
	local ok, val = pcall(require, "config.DAP.adapters." .. adapter_name)
	return ok and val or nil
end

M.handlers = {}

-- see the file lua/config/DAP/adapters/python.lua to understand this
-- the handlers are functions that are called when the adapter is loaded
-- the handler is responsible for setting up the adapter dynamically
for _, adapter_name in ipairs(M.ensure_installed) do
	local adapter = get(adapter_name)
	if adapter then
		M.handlers[adapter_name] = adapter.handler
	end
end

return M
