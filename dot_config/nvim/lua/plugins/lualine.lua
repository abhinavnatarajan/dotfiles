local icons = require("icons")

-- custom toggleterm statusline
local toggleterm = {
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
local trouble = {
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

local function get_hl_fg(name)
	local hl = vim.api.nvim_get_hl(0, {name = name, link = false, create = false})
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
		-- "sainnhe/sonokai",
		-- "folke/tokyonight.nvim",
	},
	event = "BufWinEnter",
	-- this plugin is not versioned
	config = function()
		require("lualine").setup({
			theme = "auto",
			extensions = {
				"nvim-tree",
				"lazy",
				"fzf",
				toggleterm,
				"quickfix",
				"nvim-dap-ui",
				trouble,
			},
			options = {
				disabled_filetypes = {
					winbar = { "NvimTree", "alpha" },
					statusline = { "alpha" },
				},
				component_separators = { left = icons.ui.RoundDividerRight, right = icons.ui.RoundDividerLeft },
				section_separators = { left = icons.ui.BoldRoundDividerRight, right = icons.ui.BoldRoundDividerLeft },
			},
			inactive_winbar = {
				lualine_c = {
					{
						-- cwd
						function()
							return icons.ui.FileTree
									.. " "
									.. vim.fn.getcwd()
							-- .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~:.:gs%\\v(\\.?[^/]{0,2})[^/]*/%\\1/%")
						end,
						on_click = function()
							require("telescope").extensions.file_browser.file_browser()
						end,
					},
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
					}
				}
			},
			winbar = {
				lualine_c = {
					{
						-- cwd
						function()
							return icons.ui.FileTree
									.. " "
									.. vim.fn.getcwd()
							-- .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~:.:gs%\\v(\\.?[^/]{0,2})[^/]*/%\\1/%")
						end,
						on_click = function()
							require("telescope").extensions.file_browser.file_browser()
						end,
					},
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
					}
				},
				lualine_x = {
					"overseer",
				},
			},
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
							spinners = require("copilot-lualine.spinners").dots,
							spinner_color = get_hl_fg("Constant")
						},
						show_colors = true,
						show_loading = true,
						on_click = function()
							require("CopilotChat").toggle()
						end,
					},
				},
				lualine_c = {
				},
				lualine_x = {
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
						on_click = require("utils.editing").choose_buffer_indent,
					},
				},
				lualine_y = {
					"encoding",
					{
						function()
							local symbols = {
								unix = icons.ui.Unix, -- e712
								dos = icons.ui.Windows, -- e70f
								mac = icons.ui.MacOS, -- e711
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
		})
	end,
}
