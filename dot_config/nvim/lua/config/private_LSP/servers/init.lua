local M = {}

M.ensure_installed = {
	"basedpyright", -- Python LSP
	"bashls",
	"clangd",
	"cmake",
	"cssls",
	"html",
	"jsonls",
	"julials",
	"ltex", -- LanguageTool
	"lua_ls",
	"marksman", -- Markdown
	"ruff",
	"rust_analyzer",
	"taplo",
	"texlab",
	"yamlls",
}

-- Accepts lspconfig server names
---@param server_name string
---@return table | nil
M.get = function(server_name)
	local ok, val = pcall(require, "config.LSP.servers." .. server_name)
	return ok and val or nil
end

-- setup default handler
-- the handlers are functions that are called to setup the servers
M.handlers = {
	function(server_name)
		local server = M.get(server_name)
		local config = server and server.config or {}
		require("lspconfig")[server_name].setup(config)
	end,
}
-- custom handlers
for _, server_name in ipairs(M.ensure_installed) do
	local server = M.get(server_name)
	if server and server.handler then
		M.handlers[server_name] = server.handler
	end
end

return M
