local M = {}

M.config = {
	settings = {
		ruff = {
			nativeServer = true, -- whether to use the Rust-based language server
			configurationPreference = "filesystemFirst",
			lineLength = 20, -- the line length to use for the linter and formatter
			lint = {
				select = {},   -- Rules to enable by default. See the documentation
				ignore = {},   -- Rules to disable by default. See the documentation
				preview = false, -- Whether to enable Ruff's preview mode when linting
			},
			format = {
				preview = false, -- Whether to enable Ruff's unstable preview rules when formatting
				['indent-style'] = "tab", -- "space" | "tab"
				['line-ending'] = "auto",
				['docstring-code-format'] = false
			},

		},
	}
}

return M
