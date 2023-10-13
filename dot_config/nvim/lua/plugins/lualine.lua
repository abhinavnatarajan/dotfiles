return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"navarasu/onedark.nvim",
		-- "sainnhe/sonokai",
		-- "folke/tokyonight.nvim",
	},
	event = "User FileOpened",
	config = function()
		local icons = require("icons")
		-- custom toggleterm statusline
		local toggleterm = {
			sections = {
				lualine_a = {
					function() return "Terminal " .. vim.b.toggle_number end
				},
				lualine_b = {
					{

						function()
							local ttt = require("toggleterm.terminal")
							return ttt.get(ttt.get_focused_id(), false).display_name or
								string.gsub(ttt.get(ttt.get_focused_id(), false).name, ";#toggleterm#[0-9]+", "")
						end,
						on_click = function()
							local ttt = require("toggleterm.terminal")
							local termid = tostring(ttt.get_focused_id())
							vim.cmd(termid .. "ToggleTermSetName")
						end
					}
				},
			},
			winbar = {},
			inactive_winbar = {},
			filetypes = { "toggleterm" },
		}
		-- add on_click for trouble
		local function get_trouble_mode()
			local opts = require('trouble.config').options
			local words = vim.split(opts.mode, '[%W]')
			for i, word in ipairs(words) do
				words[i] = word:sub(1, 1):upper() .. word:sub(2)
			end
			return table.concat(words, ' ')
		end
		local trouble = {
			filetypes = {"Trouble"},
			sections = {
				lualine_a = {
					{
						get_trouble_mode,
						on_click = function() require("trouble").toggle() end
					},
				},
			}
		}
		require("lualine").setup {
			theme = "auto",
			extensions = {
				"nvim-tree",
				"lazy",
				"fzf",
				toggleterm,
				"quickfix",
				"nvim-dap-ui",
				trouble
			},
			options = {
				disabled_filetypes = {
					winbar = {"NvimTree", "alpha",},
					statusline = {"alpha"},
				},
				component_separators = { left = icons.ui.RoundDividerRight, right = icons.ui.RoundDividerLeft},
				section_separators = { left = icons.ui.BoldRoundDividerRight, right = icons.ui.BoldRoundDividerLeft},
			},
			winbar = {
				lualine_c = {
					{
						function()
							local navic = require("nvim-navic")
							if navic.is_available() and navic.get_location() ~= "" then
								return navic.get_location()
							else
								return "[Active]"
							end
						end,
					},
				},
				lualine_x = {
					"overseer",
				}
			},
			inactive_winbar = {
				lualine_c = {
					{
						function()
							local navic = require("nvim-navic")
							if navic.is_available() and navic.get_location() ~= "" then
								return navic.get_location()
							else
								return "[Inactive]"
							end
						end,
					},
				},
			},
			sections = {
				lualine_a = {
					'mode',
				},
				lualine_b = {
					{
						'branch', 
						on_click = function() vim.cmd("LazyGit") end
					},
					{
						'diagnostics',
						sources = { 'nvim_workspace_diagnostic' },
						symbols = {
							error = icons.diagnostics.BoldError .. ' ',
							warn = icons.diagnostics.BoldWarning .. ' ',
							info = icons.diagnostics.BoldInformation .. ' ',
							hint = icons.diagnostics.BoldHint .. ' ',
						},
						always_visible = true,
						on_click = function() vim.cmd[[ TroubleToggle ]] end,
					},
				},
				lualine_c = {
					{
						-- cwd
						function() return icons.ui.FileTree .. " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~:.:gs%\\v(\\.?[^/]{0,2})[^/]*/%\\1/%") end,
						on_click = function() vim.cmd("Telescope file_browser") end
					},
					function() return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t") end,
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
						on_click = require("utils.editing").choose_buffer_indent
					},
				},
				lualine_y = {
					'encoding',
					'fileformat',
					{
						'filetype',
						on_click = function() vim.cmd("Telescope filetypes") end
					},
				},
				lualine_z = {
					{ "location"},
				}
			},
		}
	end
}
