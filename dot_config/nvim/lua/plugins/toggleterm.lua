local icons = require("icons")
local lazy = require("utils.lazy")
local terminal = lazy.require("toggleterm.terminal")
local ui = lazy.require("toggleterm.ui")
local cm = require('utils.component_manager')

-- need to create open/close functions because toggleterm api does not have them
-- might break if the internal api changes
local toggleterm_open = function()
	local count = vim.v.count
	if count and count >= 1 then
		local term = terminal.get_or_create_term(count)
		term:open()
	else
		if not ui.open_terminal_view() then
			local term_id = terminal.get_toggled_id()
			terminal.get_or_create_term(term_id):open()
		end
	end
end

local toggleterm_is_open = function()
	local count = vim.v.count
	if count and count >= 1 then
		local term = terminal.get(count)
		return term and term:is_open() or false
	else
		local has_open, _ = ui.find_open_windows()
		return has_open
	end
end

local toggleterm_close = function()
	local count = vim.v.count
	if count and count >= 1 then
		local term = terminal.get(count)
		if term then term:close() end
	else
		local has_open, windows = ui.find_open_windows()
		if has_open then
			ui.close_and_save_terminal_view(windows)
		end
	end
end

local toggleterm_component = cm.register_component(
	'toggleterm',
	{
		open = toggleterm_open,
		close = toggleterm_close,
		is_open = toggleterm_is_open,
	}
)

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
		{ "<leader>`f", "<CMD>TermSelect<CR>",        desc = icons.ui.Select .. " Select terminal" },
		{ "<leader>`r", "<CMD>ToggleTermSetName<CR>", desc = icons.syntax.String .. " Rename terminal" },
		{
			"<A-`>",
			function() toggleterm_component:toggle() end,
			desc = icons.ui.Terminal .. " Toggle terminal",
			mode = { "n", "i" },
		},
		{ "<C-CR>", "<CMD>ToggleTermSendCurrentLine<CR>", desc = icons.ui.Terminal .. " Run line in terminal" },
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
		}
	},
	init = function()
		vim.list_extend(require('config.keybinds').which_key_defaults,
			{ { "<Leader>`", group = icons.ui.Terminal .. " Terminals" } })
	end,
	opts = {
		size = function(term)
			if term.direction == "vertical" then
				return vim.o.columns * 0.5
			elseif term.direction == "horizontal" then
				return vim.o.lines * 0.3
			end
		end,
		open_mapping = false,   -- we set a toggle function manually
		insert_mappings = true, -- whether or not the open mapping applies in insert mode
		terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
		close_on_exit = true,   -- close the terminal window when the process exits
		-- Change the default shell. Can be a string or a function returning a string
		shell = vim.o.shell,
		auto_scroll = true, -- automatically scroll to the bottom on terminal output
		-- This field is only relevant if direction is set to 'float'
		shade_terminals = false,
		direction = 'horizontal',
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
	config = function(_, opts)
		require('toggleterm').setup(opts)
		require('autocmds').define_autocmd(
			'FileType',
			{
				pattern = "toggleterm",
				group = 'toggleterm_close_mapping',
				callback = function()
					vim.keymap.set("t", "<A-`>", function() toggleterm_component:toggle() end, { buffer = true })
				end
			}
		)
	end
}
