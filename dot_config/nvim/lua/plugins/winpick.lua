return {
	"abhinavnatarajan/winpick.nvim",
	event = "VeryLazy",
	config = function()
		require("winpick").setup {
			border = "rounded",
			filter = require("utils.windows").filter 
		}
	end
}
