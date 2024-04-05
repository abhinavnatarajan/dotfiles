require("nvim-surround").buffer_setup {
	surrounds = {
		['b'] = {
			add = function()
				return { {'**'}, {'**'} }
			end
		},
	},
	aliases = {
		['b'] = false,
	}
}

local bold_keybind = function()
	local wk = require("which-key")
	local icons = require("icons")
	wk.register ({
		["<A-b>"] = {
			"<Plug>(nvim-surround-normal)iwb",
			icons.ui.Reload .. "Make current word bold",
			mode = {'n'},
			buffer = 0,
			noremap = true,
			silent = true
		}
	})
	wk.register ({
		["<A-b>"] = {
			"<ESC><Plug>(nvim-surround-insert)",
			icons.ui.Reload .. "Make current word bold",
			mode = {'i'},
			buffer = 0,
			noremap = true,
			silent = true
		}
	})
	wk.register ({
		["<A-b>"] = {
			"<Plug>(nvim-surround-visual)b",
			icons.ui.Reload .. "Make current word bold",
			mode = {'x'},
			buffer = 0,
			noremap = true,
			silent = true
		}
	})
end

bold_keybind()
