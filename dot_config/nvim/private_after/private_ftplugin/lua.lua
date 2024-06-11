vim.keymap.set(
	{ 'n', 'i' },
	"<C-CR>",
	"<CMD>source %<CR>",
	{
		desc = require("icons").ui.Reload .. " Source current file",
		buffer = 0, -- only for current buffer
		noremap = true,
		silent = true
	}
)
