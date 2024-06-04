return {
	"junegunn/vim-easy-align",
	cmd = { "EasyAlign", "LiveEasyAlign" },
	keys = {
		{
			"ga",
			"<Plug>(EasyAlign)",
			mode = { "n", "x" },
			desc = require("icons").ui.Align .. " Align lines",
		},
		{
			"gA",
			"<Plug>(LiveEasyAlign)",
			mode = { "n", "x" },
			desc = require("icons").ui.Align .. " Align lines with preview",
		},
	}
}
