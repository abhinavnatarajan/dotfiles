local M = {}

M.setup = function()
	-- Default settings
	require("config.settings").load_defaults()
	-- Default keybindings
	require("config.keybinds").load_defaults()
	-- Events and callbacks
	require("config.hooks").load_defaults()
end

return M
