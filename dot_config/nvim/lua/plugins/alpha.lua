return {
	"goolord/alpha-nvim",
	-- alpha-nvim is not versioned
	-- version = "*",
	event = "VimEnter",
	cmd = { "Alpha" },
	keys = {
		{
			"<leader>;",
			"<CMD>Alpha<CR>",
			desc = require("icons").ui.Dashboard .. " Dashboard"
		}
	},
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local icons = require("icons")
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                     ",
		}
		dashboard.section.buttons.val = {
			dashboard.button("n", icons.ui.NewFile .. " New file", [[:ene | startinsert <CR>]], { desc = "New file" }),
			dashboard.button(
				"f",
				icons.ui.FindFile .. " Find files",
				function()
					local ok = pcall(require("telescope.builtin").git_files)
					if not ok then
						require("telescope.builtin").find_files()
					end
				end,
				{ desc = "Find files" }
			),
			dashboard.button(
				"r",
				icons.ui.History .. " Recent files",
				[[:Telescope oldfiles<CR>]],
				{ desc = "Recent files" }
			),
			dashboard.button(
				"g",
				icons.ui.FindText .. " Search text",
				[[:Telescope live_grep<CR>]],
				{ desc = "Search text" }
			),
			dashboard.button(
				"d",
				icons.ui.Folder .. " Browse directories",
				[[:Telescope file_browser<CR>]],
				{ desc = "Browse files" }
			),
			dashboard.button(
				"k",
				icons.ui.Project .. " Load workspace",
				[[:SessionManager load_session<CR>]],
				{ desc = "Load workspace" }
			),
			dashboard.button(
				"s",
				icons.ui.Gear .. " Configuration",
				function()
					require("telescope").extensions.file_browser.file_browser({cwd = "~/.config/nvim"})
				end,
				{ desc = "Browse config files" }
			),
			dashboard.button("q", icons.ui.SignOut .. " Quit NVIM", "<CMD>confirm qa<CR>"),
		}
		alpha.setup(dashboard.config)
	end,
}
