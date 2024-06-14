for _, plugin in ipairs(require("lazy").plugins()) do
	if plugin.name == "which-key.nvim" then
		vim.notify("which-key is loaded")
	end
end
