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
M.get_config_by_name = function(server_name)
	local ok, val = pcall(require, "config.LSP.servers." .. server_name)
	return ok and val.config or {}
end

return M
