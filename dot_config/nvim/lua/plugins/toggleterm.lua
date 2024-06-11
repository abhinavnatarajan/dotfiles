local icons = require("icons")
return {
	'akinsho/toggleterm.nvim',
	version = "*",
	cmd = {
		'ToggleTerm',
		'TermSelect',
		"ToggleTermSendCurrentLine",
		"ToggleTermSendVisualLines",
		"ToggleTermSendVisualSelection",
		"ToggleTermSetName",
	},
	keys = {
		{ "<leader>`f", "<CMD>TermSelect<CR>",                desc = icons.ui.Select .. " Select terminal" },
		{ "<leader>`r", "<CMD>ToggleTermSetName<CR>",         desc = icons.syntax.String .. " Rename terminal" },
		{ "<A-`>",      "<CMD>ToggleTerm<CR>",                desc = icons.ui.Terminal .. " Toggle terminal",     mode = { "n", "x" } },
		{ "<C-CR>",     "<CMD>ToggleTermSendCurrentLine<CR>", desc = icons.ui.Terminal .. " Run line in terminal" },
		{
			"<C-CR>",
			function()
				local m = vim.fn.mode()
				if m == "v" then
					return "<CMD>ToggleTermSendVisualSelection<CR>gv"
				elseif m == "V" then
					return "<CMD>ToggleTermSendVisualLines<CR>gv"
				end
			end,
			desc = icons.ui.Terminal .. " Run selection in terminal",
			mode = "x",
			expr = true,
			replace_keycodes = true
		}
	},
	opts = {
		size = 70,
		open_mapping = "<A-`>",
		insert_mappings = true, -- whether or not the open mapping applies in insert mode
		terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
		close_on_exit = true,   -- close the terminal window when the process exits
		-- Change the default shell. Can be a string or a function returning a string
		shell = vim.o.shell,
		auto_scroll = true, -- automatically scroll to the bottom on terminal output
		-- This field is only relevant if direction is set to 'float'
		shade_terminals = false,
		direction = 'vertical',
		float_opts = {
			-- The border key is *almost* the same as 'nvim_open_win'
			-- see :h nvim_open_win for details on borders however
			-- the 'curved' border is a custom border type
			-- not natively supported but implemented in this plugin.
			border = "rounded", -- other options supported by win_open
			-- like `size`, width and height can be a number or function which is passed the current terminal
			-- width = <value>,
			-- height = <value>,
			winblend = 5,
			-- zindex = <value>,
		},
		winbar = {
			enabled = false,
			name_formatter = function(term) --  term: Terminal
				return term.name
			end
		},
	},
	config = function(_, setup_opts)
		require("toggleterm").setup(setup_opts)
		vim.api.nvim_create_user_command("ToggleTermSendCurrentLine",
			function(opts)
				require("toggleterm").send_lines_to_terminal("single_line", false, opts.args)
			end,
			{ nargs = "?", force = true }
		)
		vim.api.nvim_create_user_command("ToggleTermSendVisualSelection",
			function(opts)
				require("toggleterm").send_lines_to_terminal("visual_selection", false, opts.args)
			end,
			{ range = true, nargs = "?", force = true }
		)
		vim.api.nvim_create_user_command("ToggleTermSendVisualLines",
			function(opts)
				require("toggleterm").send_lines_to_terminal("visual_lines", false, opts.args)
			end,
			{ range = true, nargs = "?", force = true }
		)
		require("autocmds").define_autocmd(
		-- no sign column in toggleterm
			"TermOpen",
			{
				group = "no_signs_in_toggleterm",
				pattern = "term://*toggleterm#*",
				callback = function()
					vim.opt_local.signcolumn = "no"
				end,
			}
		)
	end,
}
