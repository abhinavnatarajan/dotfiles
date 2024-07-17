local M = {}

M.config = {
	init_options = {
		buildDirectory = "${workspaceFolder}/build",
	},
	root_dir = function(fname)
		return vim.fs.root(fname, { "CMakeLists.txt", "CMakePresets.json", "CMakeUserPresets.json" })
	end,
}

return M
