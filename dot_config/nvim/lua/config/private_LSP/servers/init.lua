local M = {}

M.ensure_installed = {
	"lua_ls",
	"julials",
	"bashls",
	-- Python LSP
	"basedpyright",
	"ruff",
	-- Markdown
	"marksman",
	"html",
	"texlab",
	"jsonls",
	"yamlls",
	"clangd",
	"cmake",
	"taplo",
	"cssls",
	"rust_analyzer",
	-- LanguageTool
	"ltex",
}

-- Accepts lspconfig server names
M.get_config_by_name = function(server_name)
	local ok, val = pcall(require, "config.LSP.servers." .. server_name)
	return ok and val.config or {}
end

return M
