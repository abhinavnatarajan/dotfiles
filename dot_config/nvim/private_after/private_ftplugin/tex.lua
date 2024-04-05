require('nvim-surround').buffer_setup({
	-- Configuration here, or leave empty to use defaults
	surrounds = {
		["e"] = {
			add = function()
				local env = require("nvim-surround.config").get_input "Environment: "
				return { { "\\begin{" .. env .. "}" }, { "\\end{" .. env .. "}" } }
			end,
		},
		["c"] = {
			add = function()
				local cmd = require("nvim-surround.config").get_input "Command: "
				return { { "\\" .. cmd .. "{" }, { "}" } }
			end,
		},
	}
})

