return {
	'nvim-tree/nvim-web-devicons',
	init = function()
		require("autocmds").define_autocmd(
			"ColorScheme",
			{
				desc = "Refresh nvim-web-devicons",
				pattern = "*",
				group = "nvim_web_devicons_refresh",
				callback = function()
					require("nvim-web-devicons").refresh()
				end,
			}
		)
	end
}
