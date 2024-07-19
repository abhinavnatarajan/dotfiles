local icons = require("icons")
local lazy = require("utils.lazy")
local cm = require("utils.component_manager")
local trouble = lazy.require('trouble')

local function make_kmap(item)
	local component = cm.register_component(item.component_name, {
		is_open = function() return trouble.is_open(item.trouble_name) end,
		open = function() trouble.open(item.trouble_name) end,
		close = function() trouble.close(item.trouble_name) end
	})
	return {
		item.key,
		function() component:toggle() end,
		desc = item.desc,
	}
end
local keys = vim.tbl_map(make_kmap, {
	{
		key = "<leader>ld",
		component_name = "trouble_diagnostics",
		trouble_name = 'Workspace diagnostics',
		desc = icons.ui.Diagnostics .. " Toggle diagnostics",
	},
	{
		key = "<leader>lb",
		trouble_name = 'Document diagnostics',
		component_name = "trouble_document_diagnostics",
		desc = icons.ui.Diagnostics .. " Toggle diagnostics (document)",
	},
	{
		key = "<leader>lr",
		trouble_name = 'References',
		component_name = "trouble_references",
		desc = icons.ui.Diagnostics .. " Toggle LSP references",
	},
	{
		key = "<leader>ll",
		component_name = "trouble_location_list",
		trouble_name = 'Location list',
		desc = icons.ui.Location .. " Toggle loclist",
	},
	{
		key = "<leader>lf",
		component_name = "trouble_quickfix_list",
		trouble_name = 'Quickfix list',
		desc = icons.ui.Fix .. " Toggle quickfix",
	},
})
vim.list_extend(keys, {
	{
		"<leader>ls",
		function() trouble.toggle('Document symbols') end,
		desc = icons.ui.Stacks .. " Document symbols"
	},
})

return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	event = { "LspAttach", "QuickFixCmdPre" },
	cmd = { "Trouble" },
	keys = keys,
	init = function()
		vim.list_extend(require('config.keybinds').which_key_defaults,
			{ { "<Leader>l", group = icons.ui.Diagnostics .. " Diagnostics" } })
	end,
	config = function()
		---make Trouble use the same color as a normal buffer
		vim.api.nvim_set_hl(0, "TroubleNormal", { link = "Normal" })

		---make Trouble the default quickfix list
		require("autocmds").define_autocmd(
			"FileType",
			{
				desc = "Replace quickfix with trouble",
				group = "trouble_qf",
				pattern = { "qf" },
				callback = function()
					local qfclosecmd, qftrouble
					if vim.fn.getwininfo(vim.fn.win_getid())[1]["loclist"] == 1 then
						qfclosecmd = "lclose"
						qftrouble = "trouble_location_list"
					else
						qfclosecmd = "cclose"
						qftrouble = "trouble_quickfix_list"
					end
					vim.schedule(function()
						vim.cmd(qfclosecmd)
						cm.ComponentList[qftrouble]:show()
					end)
				end,
			}
		)

		---make Trouble the default handler for LSP references
		vim.g.lsp_reference_handler = function() cm.ComponentList['trouble_references']:show() end

		-- actual options
		require("trouble").setup {
			auto_preview = false, -- automatically open preview when on an item
			focus = true,        -- Focus the window when opened
			open_no_results = true, -- open the trouble window when there are no results
			-- window options for the results window. Can be a split or a floating window.
			win = {
				type = "split",
				position = "bottom",
				relative = "editor",
				size = vim.o.lines * 0.3,
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
				["Quickfix list"] = {
					desc = "Quickfix",
					mode = "qflist",
				},
				["References"] = {
					desc = "References",
					mode = "lsp_references",
					auto_preview = true,
				},
				["Document symbols"] = {
					desc = "Document Symbols",
					mode = "lsp_document_symbols",
					win = {
						type = "split",
						position = "left",
						relative = "editor",
						size = vim.o.columns * 0.25,
					},
					filter = {
						-- remove Package since luals uses it for control flow structures
						["not"] = { ft = "lua", kind = "Package" },
						any = {
							-- all symbol kinds for help / markdown files
							-- ft = { "help", "markdown" },
							-- default set of symbol kinds
							kind = {
								"Class",
								"Constant",
								"Constructor",
								"Enum",
								"Event",
								-- "Field",
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
								"Trait"
							},
						},
					},
				}
			},
			icons = {
				indent = {
					last = "╰╴", -- rounded
				},
				folder_closed = icons.ui.Folder .. " ",
				folder_open = icons.ui.FolderOpen .. " ",
				kinds = icons.syntax
			},
		}
	end
}
