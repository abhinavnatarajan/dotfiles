local source_file_keybind = function()
	local wk = require("which-key")
	local icons = require("icons")
	wk.register ({
		["<C-CR>"] = {
			"<CMD>source %<CR>",
			icons.ui.Reload .. " Source current file",
			mode = {'n', 'i'},
			buffer = 0,
			noremap = true,
			silent = true
		}
	})
end

source_file_keybind()
