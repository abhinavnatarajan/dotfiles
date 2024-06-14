return {
	"famiu/bufdelete.nvim",
	-- this plugin is not versioned
	-- version = "*",
	event = "BufWinEnter",
	keys = {
		{ "<leader>c", function() require("bufdelete").bufdelete(0, true) end, desc = require("icons").ui.BoldClose .. " Close buffer" }
	},
	cmd = { "Bdelete", "Bwipeout" },
}
