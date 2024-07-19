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
	},
	event = { "CmdlineEnter" },
	init = function()
		require("autocmds").define_autocmd(
			"CmdlineEnter",
			{
				group = "flash_enable_search_mode_keybind",
				pattern = "[/?]",
				callback = function()
					vim.keymap.set(
						"c",
						"<F1>",
						function()
							require("flash").toggle()
						end,
						require("config.keybinds").DefaultOpts { desc = "Toggle flash search mode" }
					)
				end
			}
		)
		require("autocmds").define_autocmd(
			"CmdlineLeave",
			{
				group = "flash_disable_search_mode_keybind",
				pattern = "[/?]",
				callback = function()
					require("flash").toggle(false)
					vim.keymap.del("c", "<F1>")
				end
			}
		)
	end
}
