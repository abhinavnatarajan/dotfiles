return {
	"navarasu/onedark.nvim",
	event = "VeryLazy",
	priority = 1000,
	-- this plugin is not versioned
	config = function()
		local colours_to_darken = { -- darker background for more contrast
			bg0 = 0.25,
			bg1 = 0.25,
			bg2 = 0.25,
			bg3 = 0.25,
			bg_d = 0.3,
		}
		local colours_to_lighten = { -- lighter comments and delimiters
			grey = 0.1, -- mostly comments
			fg = 0.15 -- text
		}
		local replacement_colours = {}
		for name, val in pairs(colours_to_darken) do
			replacement_colours[name] = require("onedark.util").darken(
				"#000000",
				val,
				require("onedark.palette").darker[name]
			)
		end
		for name, val in pairs(colours_to_lighten) do
			replacement_colours[name] = require("onedark.util").lighten(
				"#ffffff",
				val,
				require("onedark.palette").darker[name]
			)
		end
		replacement_colours["dark_grey"] = require("onedark.util").darken(
			'#000000', 0.25, require('onedark.palette').darker.grey
		)
		require('onedark').setup {
			-- Main options --
			style = 'darker',          -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
			transparent = false,       -- Show/hide background
			term_colors = true,        -- Change terminal color as per the selected theme style
			ending_tildes = true,      -- Show the end-of-buffer tildes. By default they are hidden
			cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

			-- toggle theme style ---
			toggle_style_key = "<leader>sC",                                                -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
			toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

			-- Change code style ---
			-- Options are italic, bold, underline, none
			-- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
			code_style = {
				comments = 'italic',
				keywords = 'none',
				functions = 'none',
				strings = 'none',
				variables = 'none'
			},

			-- Lualine options --
			lualine = {
				transparent = false, -- lualine center bar transparency
			},

			-- Custom Highlights --
			colors = replacement_colours, -- Override default colors
			highlights = {
				MatchParen = { bg = '$dark_grey' }, -- background of matched delimiters
				-- Search highlights
				CurSearch = { bg = '$yellow' },
				IncSearch = { bg = '$yellow' },
				Search = { bg = '$dark_yellow' },
				CmpGhostText = { fg = '$grey', fmt = 'italic' },
				GitSignsAdd = { fg = '$green', fmt = "bold" },
				GitSignsChange = { fg = '$blue', fmt = "bold" },
				GitSignsDelete = { fg = '$red', fmt = "bold" },
				GitSignsCol = { fg = '$grey', fmt = "bold", },
				CursorLineSign = { fg = '$grey', fmt = "bold" },
			}, -- Override highlight groups

			-- Plugins Config --
			diagnostics = {
				darker = false, -- darker colors for diagnostic
				undercurl = true, -- use undercurl instead of underline for diagnostics
				background = true, -- use background color for virtual text
			},
		}
		require('onedark').load()
		vim.keymap.set("n", "<leader>sC", function() require("onedark").toggle() end,
			{ desc = "Toggle Onedark colourscheme" })
	end
}
