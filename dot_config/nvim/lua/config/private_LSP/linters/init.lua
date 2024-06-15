local M = {}

M.ensure_installed = {
	"actionlint",
	"codespell",
	"editorconfig-checker",
	"vale"
}

-- accepts null-ls names
M.get = function(linter_name)
	local ok, val = pcall(require, "config.LSP.linters." .. linter_name)
	if ok then
		return val
	else
		return nil
	end
end

M.handlers = {}
-- see the file lua/config/LSP/linters/vale.lua to understand this
-- the handlers are functions that are called when none-ls is loaded
for _, linter in ipairs(M.ensure_installed) do
	if M.get(linter) ~= nil then
		M.handlers[linter] = M.get(linter).handler
	end
end

return M
