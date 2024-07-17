local M = {}

M.config = {
	on_attach = function()
		require("ltex_extra").setup()
	end,
	flags = {
		debounce_text_changes = 500,
	},
	settings = {
		ltex = {
			enabled = {
				"latex",
				"tex",
				"markdown",
				"bibtex",
				"restructuredtext",
				"plaintext",
				"git-commit",
				-- "html",
			},
			language = "en-GB",
			checkFrequency = "save",
			-- configurationTarget = {
			-- 	dictionary = "workspaceFolderExternalFile",
			-- 	hiddenFalsePositives = "workspaceFolderExternalFile",
			-- 	disabledRules = "workspaceFolderExternalFile"
			-- },
			["ltex-ls"] = { logLevel = "config" },
			latex = {
				commands = {
					["\\label"] = "ignore",
					["\\fullref"] = "dummy",
					["\\cref"] = "dummy",
					["\\nameref"] = "dummy",
				},
				environments = {
					["diagram"] = "ignore",
				},
			},
		},
	},
}

return M
