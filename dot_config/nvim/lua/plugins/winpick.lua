return {
	"abhinavnatarajan/winpick.nvim",
	lazy = true,
	config = function()
		require("winpick").setup {
			border = "rounded",
			filter = require("utils.windows").filter 
		}
	end
}
