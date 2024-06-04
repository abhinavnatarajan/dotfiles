return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	event = { "LspAttach", "QuickFixCmdPre" },
	cmd = { "Trouble" },
	keys = function()
		local bottom_modes = {
			"Workspace diagnostics",
			"Document diagnostics",
			"Location list",
			"Quickfix",
			-- "Document symbols"
		}
		local toggle_bottom_window = function(mode)
			local trouble = require("trouble")
			if trouble.is_open(mode) then
				trouble.close(mode)
			else
				if vim.tbl_contains(bottom_modes, mode) then
					for _, name in ipairs(bottom_modes) do
						trouble.close(name)
					end
				end
				trouble.open(mode)
			end
		end
		local icons = require("icons")
		local wk = require("which-key")
		wk.register({ ["<leader>l"] = { name = icons.ui.DebugConsole .. " Diagnostics" } })
		return {
			{
				"<leader>ld",
				function() toggle_bottom_window("Workspace diagnostics") end,
				desc = icons.ui.DebugConsole .. " Toggle diagnostics",
			},
			{
				"<leader>lb",
				function() toggle_bottom_window("Document diagnostics") end,
				desc = icons.ui.DebugConsole .. " Toggle diagnostics (document)",
			},
			{
				"<leader>ll",
				function() toggle_bottom_window("Location list") end,
				desc = icons.ui.Location .. " Toggle loclist",
			},
			{
				"<leader>lf",
				function() toggle_bottom_window("Quickfix") end,
				desc = icons.ui.Fix .. " Toggle quickfix",
			},
			{
				"<leader>ls",
				function() require("trouble").toggle("Document symbols") end,
				desc = icons.ui.Stacks .. " Document symbols"
			}
		}
	end,
	config = function()
		require("trouble").setup {
			auto_close = false,   -- auto close when there are no items
			auto_open = false,    -- auto open when there are items
			auto_preview = true,  -- automatically open preview when on an item
			auto_refresh = true,  -- auto refresh when open
			auto_jump = false,    -- auto jump to the item when there's only one
			focus = true,         -- Focus the window when opened
			restore = true,       -- restores the last location in the list when opening
			follow = true,        -- Follow the current item
			indent_guides = true, -- show indent guides
			max_items = 200,      -- limit number of items that can be displayed per section
			multiline = true,     -- render multi-line messages
			pinned = false,       -- When pinned, the opened trouble window will be bound to the current buffer
			warn_no_results = false, -- show a warning when there are no results
			open_no_results = true, -- open the trouble window when there are no results
			win = {
				type = "split",
				position = "bottom",
				relative = "editor",
			},
			-- window options for the results window. Can be a split or a floating window.
			-- Window options for the preview window. Can be a split, floating window,
			-- or `main` to show the preview in the main editor window.
			preview = {
				type = "main",
				-- when a buffer is not yet loaded, the preview window will be created
				-- in a scratch buffer with only syntax highlighting enabled.
				-- Set to false, if you want the preview to always be a real loaded buffer.
				scratch = false,
			},
			-- Throttle/Debounce settings. Should usually not be changed.
			throttle = {
				refresh = 20,                        -- fetches new data when needed
				update = 10,                         -- updates the window
				render = 10,                         -- renders the window
				follow = 100,                        -- follows the current item
				preview = { ms = 100, debounce = true }, -- shows the preview for the current item
			},
			-- Key mappings can be set to the name of a builtin action,
			-- or you can define your own custom action.
			keys = {
				["?"] = "help",
				r = "refresh",
				R = "toggle_refresh",
				q = "close",
				o = "jump_close",
				["<esc>"] = "cancel",
				["<cr>"] = "jump",
				["<2-leftmouse>"] = "jump",
				["<c-s>"] = "jump_split",
				["<c-v>"] = "jump_vsplit",
				-- go down to next item (accepts count)
				-- j = "next",
				["}"] = "next",
				["]]"] = "next",
				-- go up to prev item (accepts count)
				-- k = "prev",
				["{"] = "prev",
				["[["] = "prev",
				i = "inspect",
				p = "preview",
				P = "toggle_preview",
				zo = "fold_open",
				zO = "fold_open_recursive",
				zc = "fold_close",
				zC = "fold_close_recursive",
				za = "fold_toggle",
				zA = "fold_toggle_recursive",
				zm = "fold_more",
				zM = "fold_close_all",
				zr = "fold_reduce",
				zR = "fold_open_all",
				zx = "fold_update",
				zX = "fold_update_all",
				zn = "fold_disable",
				zN = "fold_enable",
				zi = "fold_toggle_enable",
				s = { -- example of a custom action that toggles the severity
					action = function(view)
						local f = view:get_filter("severity")
						local severity = ((f and f.filter.severity or 0) + 1) % 5
						view:filter({ severity = severity }, {
							id = "severity",
							template = "{hl:Title}Filter:{hl} {severity}",
							del = severity == 0,
						})
					end,
					desc = "Toggle Severity Filter",
				},
			},
			modes = {
				["Workspace diagnostics"] = {
					desc = "Workspace diagnostics",
					mode = "diagnostics",
				},
				["Document diagnostics"] = {
					desc = "Document diagnostics",
					mode = "diagnostics",
					filter = { buf = 0 },
				},
				["Location list"] = {
					desc = "Location list",
					mode = "loclist",
				},
				["Quickfix"] = {
					desc = "Quickfix",
					mode = "qflist",
				},
				["Document symbols"] = {
					desc = "Document Symbols",
					mode = "lsp_document_symbols",
					win = {
						type = "split",
						position = "left",
						relative = "editor",
						width = 80,
					},
					filter = {
						-- remove Package since luals uses it for control flow structures
						["not"] = { ft = "lua", kind = "Package" },
						any = {
							-- all symbol kinds for help / markdown files
							-- ft = { "help", "markdown" },
							-- default set of symbol kinds
							kind = {
								"Array",
								"Boolean",
								"Class",
								"Constant",
								"Constructor",
								"Enum",
								"EnumMember",
								"Event",
								-- "Field",
								"File",
								"Function",
								"Interface",
								-- "Key",
								"Method",
								"Module",
								"Namespace",
								-- "Null",
								-- "Number",
								"Object",
								"Operator",
								"Package",
								"Property",
								-- "String",
								"Struct",
								"TypeParameter",
								"Variable",
							},
						},
					},

				}
			},
			icons = {
				indent = {
					top = "│ ",
					middle = "├╴",
					last = "╰╴", -- rounded
					fold_open = " ",
					fold_closed = " ",
					ws = "  ",
				},
				folder_closed = " ",
				folder_open = " ",
				kinds = require("icons").syntax
			},
		}
		vim.api.nvim_set_hl(0, "TroubleNormal", { link = "Normal" })
	end
}
