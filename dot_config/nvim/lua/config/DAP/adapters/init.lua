local M = {}

M.ensure_installed = {
	"python", -- debugpy
	"cppdbg", -- cpptools
}

-- accepts nvim-dap adapter names
M.get = function(adapter_name)
	local ok, val = pcall(require, "config.DAP.adapters." .. adapter_name)
	if ok then
		return val
	else
		return nil
	end
end

M.handlers = {}
-- see the file lua/config/DAP/adapters/python.lua to understand this
-- the handlers are functions that are called when the adapter is loaded
-- the handler is responsible for setting up the adapter dynamically
for _, adapter in ipairs(M.ensure_installed) do
	if M.get(adapter) ~= nil then
		M.handlers[adapter] = M.get(adapter).handler
	end
end

return M
