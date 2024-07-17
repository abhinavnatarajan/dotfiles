local M = {}

-- null-ls names
M.ensure_installed = {
	"actionlint",
	"codespell",
	"editorconfig-checker",
	"vale"
}

M.setup = function()
	-- setup linters and hook them into the LSP client via none-ls
	for _, linter_name in ipairs(M.ensure_installed) do
		require("config.linters." .. linter_name).setup()
	end
end

return M
