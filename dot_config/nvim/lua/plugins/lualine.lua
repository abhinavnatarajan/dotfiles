local icons = require("icons")

-- custom toggleterm statusline
local toggleterm_extension = {
	sections = {
		lualine_a = {
			function()
				return "Terminal " .. vim.b.toggle_number
			end,
		},
		lualine_b = {
			{
				function()
					local ttt = require("toggleterm.terminal")
					return ttt.get(ttt.get_focused_id(), false).display_name
							or string.gsub(ttt.get(ttt.get_focused_id(), false).name, ";#toggleterm#[0-9]+", "")
				end,
				on_click = function()
					local ttt = require("toggleterm.terminal")
					local termid = tostring(ttt.get_focused_id())
					vim.cmd(termid .. "ToggleTermSetName")
				end,
			},
		},
	},
	winbar = {},
	inactive_winbar = {},
	filetypes = { "toggleterm" },
}

-- add on_click for trouble
local trouble_extension = {
	filetypes = { "trouble" },
	winbar = {},
	inactive_winbar = {},
	sections = {
		lualine_a = {
			{
				function() return vim.w.trouble.mode end,
				on_click = function()
					require("trouble").close(vim.w.trouble.mode)
				end,
			},
		},
	},
}

local overseer_extension = {
	filetypes = { "OverseerList" },
	winbar = {},
	inactive_winbar = {},
	sections = {
		lualine_a = {
			{
				function() return "OverseerList" end,
				on_click = function()
					vim.cmd("OverseerToggle")
				end,
			},
		},
	}
}

local function get_hl_fg(name)
	local hl = vim.api.nvim_get_hl(0, { name = name, link = false, create = false })
	if hl.fg then
		return string.format("#%06x", hl.fg)
	end
	return "#000000"
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"navarasu/onedark.nvim",
		'AndreM222/copilot-lualine'
	},
	event = "BufWinEnter",
	-- enabled = false,
	-- this plugin is not versioned
	config = function()
		require("lualine").setup {
			theme = "auto",
			extensions = {
				"aerial",
				"nvim-tree",
				overseer_extension,
				"lazy",
				"fzf",
				toggleterm_extension,
				"quickfix",
				"nvim-dap-ui",
				trouble_extension,
				"mason",
			},
			options = {
				disabled_filetypes = {
					winbar = {
						"NvimTree",
						"alpha",
						'dap-repl',
						'dapui_console',
						'dapui_watches',
						'dapui_stacks',
						'dapui_breakpoints',
						'dapui_scopes',
					},
					statusline = { "alpha" },
				},
				component_separators = { left = icons.ui.RoundDividerRight, right = icons.ui.RoundDividerLeft },
				section_separators = { left = icons.ui.BoldRoundDividerRight, right = icons.ui.BoldRoundDividerLeft },
			},
			-- inactive_winbar = {
			-- 	lualine_c = {
			-- 		{
			-- 			-- cwd
			-- 			function()
			-- 				return icons.ui.FileTree
			-- 						.. " "
			-- 						.. vim.fn.getcwd()
			-- 				-- .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~:.:gs%\\v(\\.?[^/]{0,2})[^/]*/%\\1/%")
			-- 			end,
			-- 			on_click = function()
			-- 				require("telescope").extensions.file_browser.file_browser()
			-- 			end,
			-- 		},
			-- },
			sections = {
				lualine_a = {
					"mode",
					{
						-- check if we are recording a macro
						function()
							local register = vim.fn.reg_recording()
							if register ~= "" then
								register = "@" .. register
							end
							return register
						end,
						always_visible = false,
					},
				},
				lualine_b = {
					{
						"branch",
						on_click = function() require("lazygit").lazygit() end
					},
					{
						"diagnostics",
						sources = { "nvim_workspace_diagnostic" },
						symbols = {
							error = icons.diagnostics.BoldError .. " ",
							warn = icons.diagnostics.BoldWarning .. " ",
							info = icons.diagnostics.BoldInformation .. " ",
							hint = icons.diagnostics.BoldHint .. " ",
						},
						always_visible = true,
						on_click = function()
							require("trouble").open("Workspace diagnostics")
						end,
					},
					{
						'copilot',
						-- Default values
						symbols = {
							status = {
								icons = {
									enabled = " ",
									sleep = " ", -- auto-trigger disabled
									disabled = " ",
									warning = " ",
									unknown = " "
								},
								hl = {
									enabled = get_hl_fg("DiagnosticOk"),
									sleep = get_hl_fg("DiagnosticUnnecessary"),
									disabled = get_hl_fg("DiagnosticUnnecessary"),
									warning = get_hl_fg("DiagnosticWarn"),
									unknown = get_hl_fg("DiagnosticError")
								}
							},
							spinners = icons.ui.Spinner,
							spinner_color = get_hl_fg("Constant")
						},
						show_colors = true,
						show_loading = true,
						on_click = function()
							require("CopilotChat").toggle()
						end,
					},
					{
						"overseer",
						on_click = function()
							vim.cmd("OverseerToggle")
						end,
					},
				},
				lualine_c = {},
				lualine_x = {
					{
						-- filename
						function()
							return vim.fn.fnamemodify(
								vim.api.nvim_buf_get_name(0),
								":~:.:g" -- make relative to cwd
							)
						end,
						on_click = function()
							require("telescope.builtin").find_files()
							-- s%\\v(\\.?[^/]{0,2})[^/]*/%\\1/
						end,
					},
				},
				lualine_y = {
					{
						function()
							if vim.bo.expandtab then
								if vim.bo.shiftwidth == 0 then
									return icons.ui.SpaceCharacter .. " " .. tostring(vim.bo.tabstop)
								else
									return icons.ui.SpaceCharacter .. " " .. tostring(vim.bo.shiftwidth)
								end
							else
								return icons.ui.TabCharacter .. " " .. tostring(vim.bo.tabstop)
							end
						end,
						on_click = function() require("utils.editing").select_indent(true) end,
					},
					"encoding",
					{
						function()
							local symbols = {
								unix = icons.ui.Unix, -- LF
								dos = icons.ui.Windows, -- CRLF
								mac = icons.ui.MacOS, -- CR
							}
							return symbols[vim.bo.fileformat]
						end,
						on_click = require("utils.editing").choose_file_newline,
					},
					{
						"filetype",
						on_click = function()
							require("telescope.builtin").filetypes()
						end,
					},
				},
				lualine_z = {
					{ "location" },
				},
			},
		}
	end
}
