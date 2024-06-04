return {
	"famiu/bufdelete.nvim",
	-- this plugin is not versioned
	-- version = "*",
	keys = {
		{ "<leader>c", "<CMD>confirm Bdelete<CR>", desc = require("icons").ui.BoldClose .. " Close buffer" }
	},
	cmd = { "Bdelete", "Bwipeout" },
}
