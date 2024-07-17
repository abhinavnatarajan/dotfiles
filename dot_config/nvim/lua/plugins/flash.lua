return {
	"folke/flash.nvim",
	version = "*",
	keys = {
		{
			"g<space>",
			function() require('flash').jump() end,
			desc = require("icons").ui.BoldArrowRight .. " Flash jump",
			mode = { "n", "x", "o" },
		},
		{
			"g<Tab>",
			function() require('flash').treesitter() end,
			desc = "Flash treesitter",
			mode = { "n", "x", "o" },
		}
	}
}
