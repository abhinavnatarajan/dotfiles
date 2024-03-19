local M = {}

local DefaultOpts = require("utils").prototype {
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}
local icons = require("icons")

M.which_key_defaults = {
	{
		-- File shortcuts
		mapping = {
			["<leader>"] = {
				name = icons.ui.Files .. " Leader shortcuts",
				[";"] = { "<CMD>Alpha<CR>", icons.ui.Dashboard .. " Dashboard" },
				["n"] = { [[<CMD>lua require("utils.windows").edit_new_file_handler()<CR>]], icons.ui.NewFile .. " New file" },
				["w"] = { [[<CMD>lua require("telescope_custom_pickers").check_save_as()<CR>]], icons.ui.Save .. " Save" },
				["<A-w>"] = { [[<CMD>lua require("telescope_custom_pickers").save_as()<CR>]], icons.ui.SaveAs .. " Save as" },
				["W"] = { "<CMD>wa!<CR>", icons.ui.SaveAll .. " Save all" },
				["c"] = { "<CMD>confirm Bdelete<CR>", icons.ui.BoldClose .. " Close buffer" },
				["e"] = { "<CMD>silent NvimTreeToggle<CR>", icons.ui.FileTree .. " Explorer" },
				["q"] = { "<CMD>confirm q<CR>", icons.ui.BoldClose .. " Close window" },
				["Q"] = { "<CMD>qa!<CR>", icons.ui.BoldClose .. " Quit" },
				["%"] = { "<CMD>cd %:p:h<CR>", icons.ui.FolderActive .. " Set working directory from active buffer" },
				["-"] = { "<CMD>cd ..<CR>", icons.ui.FolderUp .. " Go up one directory" },
				["h"] = { "<CMD>Telescope help_tags<CR>", icons.ui.FindFile .. " Search in help topics" },
				["\\"] = { "<CMD>Noice telescope<CR>", icons.ui.Notification .. " Notification history" },
				["s"] = {
					name = icons.ui.Gear.. " Settings",
					["c"] = { "<CMD>Telescope colorscheme enable_preview=true<CR>", icons.ui.ColourScheme .. " Colorscheme" },
					["f"] = { [[<CMD>lua require("telescope_custom_pickers").config()<CR>]], icons.ui.ConfigFolder .. " Browse config files" },
					["i"] = { require("utils.editing").choose_global_indent, icons.ui.Indent .. " Set indentation" },
				},
				["k"] = {
					name = icons.ui.Project .. " Workspaces",
					["f"] = { [[<CMD>SessionManager load_session<CR>]], icons.ui.FindFolder .. " Load workspace" },
					["r"] = { [[<CMD>SessionManager load_last_session<CR>]], icons.ui.History .. " Load last session" },
					["d"] = { [[<CMD>SessionManager delete_session<CR>]], icons.ui.Trash .. " Delete workspace"},
					["w"] = { "<CMD>SessionManager save_current_session<CR>", icons.ui.Save .. " Save current workspace" },
				},
				["f"] = {
					name = icons.ui.Files .. " Files",
					["f"] = { [[<CMD>lua require("telescope.builtin").find_files()<CR>]], icons.ui.FindFile .. " Find files in cwd" },
					["d"] = { "<CMD>Telescope file_browser<CR>", icons.ui.FolderOpen .. " Browse files" },
					["g"] = { [[<CMD>Telescope live_grep<CR>]], icons.ui.FindText .. " Search text" },
					["r"] = { [[<CMD>Telescope oldfiles<CR>]], icons.ui.History .. " Recent files" },
					["t"] = { [[<CMD>Telescope filetypes<CR>]], icons.syntax.Text .. " Set filetype" },
					["i"] = { require("utils.editing").choose_buffer_indent, icons.ui.Indent .. " Set indentation" },
				},
				["P"] = {
					name = icons.ui.ToolBox .. " Plugins",
					["m"] = { "<CMD>Lazy home<CR>", icons.ui.Configure .. " Manage plugins" },
					["f"] = { "<CMD>Telescope lazy<CR>", icons.ui.FolderOpen .. " Explore plugin files" },
				},
				["b"] = {
					name = icons.ui.Files .. " Buffers",
					["j"] = { "<CMD>BufferLinePick<CR>", icons.ui.GotoFile .. " Jump to buffer" },
					["f"] = { [[<CMD> lua require("telescope_custom_pickers").buffers()<CR>]], icons.ui.FindFile .. " Find buffer" },
					["p"] = { "<CMD>BufferLineTogglePin<CR>", icons.ui.Pin .. " Pin buffer" },
				},
				["g"] = {
					name = icons.git.Git .. " Git",
					["g"] = { "<CMD>LazyGit<CR>", icons.git.Branch .. " Open lazygit console" },
					["s"] = { function() require("gitsigns").stage_hunk() end, "Stage hunk" },
					["r"] = { function() require("gitsigns").reset_hunk() end, "Reset hunk" },
					["u"] = { function() require("gitsigns").undo_stage_hunk() end, "Undo stage hunk" },
					["p"] = { function() require("gitsigns").preview_hunk() end, "Preview hunk" },
					["S"] = { function() require("gitsigns").stage_buffer() end, "Stage buffer" },
					["R"] = { function() require("gitsigns").reset_buffer() end, "Reset buffer" },
					["d"] = { function() require("gitsigns").diffthis(nil,{ split = "rightbelow" }) end, "Diff this" },
					["D"] = { function() require("gitsigns").diffthis("~") end, "Diff this" },
					["t"] = { function() require("gitsigns").toggle_deleted() end, "Toggle deleted" },
				},
				["x"] = {
					name = icons.ui.DebugConsole .. " Diagnostics",
					["x"] = { "<CMD>TroubleToggle<CR>", icons.ui.DebugConsole .. " Toggle diagnostics" },
					["w"] = { "<CMD>TroubleToggle workspace_diagnostics<CR>", icons.ui.Project .. " Workspace diagnostics" },
					["d"] = { "<CMD>TroubleToggle document_diagnostics<CR>", icons.ui.CodeFile .. " Document diagnostics" },
					["q"] = { "<CMD>TroubleToggle quickfix<CR>", icons.ui.Fix .. " Quickfix" },
					["l"] = { "<CMD>TroubleToggle loclist<CR>", icons.ui.Location .. " Location list" },
				},
				["L"] = {
					name = icons.ui.Lightbulb .. " LSP",
					["m"] = { "<CMD>Mason<CR>", icons.ui.Configure .. " Manage installed LSP servers" },
				},
				["t"] = {
					name = icons.ui.Tab .. " Tabs",
					["e"] = { "<CMD>tab split<CR>", icons.ui.Edit .. " Edit in new tab" },
					["o"] = { "<CMD>tabonly<CR>", "Close all other tabs" },
					["n"] = { "<CMD>tab split<CR>", icons.ui.OpenInNew .. " New file in new tab" },
					["c"] = { "<CMD>tab close<CR>", "Close current tab" },
					["H"] = { "<CMD>silent! tabmove -1<CR>", icons.ui.BoldArrowLeft .. " Move tab to the left" },
					["L"] = { "<CMD>silent! tabmove +1<CR>", icons.ui.BoldArrowRight .. " Move tab to the right" },
					["f"] = { "<CMD>tabs<CR>", icons.ui.FindTab .. " Find tabs" },
					["j"] = {
						function()
							vim.ui.input(
								{prompt = "Go to tab:" },
								function(input)
									vim.cmd("silent! tabnext" .. input)
								end
							)
						end,
						"Jump to tab"
					}
				},
				["`"] = {
					name = icons.ui.Terminal .. " Terminals",
					["f"] = {"<CMD>TermSelect<CR>", icons.ui.Select .. " Select terminal"},
					["r"] = {"<CMD>ToggleTermSetName<CR>", icons.syntax.String .. " Rename terminal"}
				},
				["u"] = { "<CMD>Telescope undo<CR>", icons.ui.Undo .. " Undo history" }
			},
			["\\"] = { [[<CMD>lua require('notify').dismiss({pending = true, silent=true})<CR>]], "Dismiss notifications"},
			["gx"] = { [[:exe 'silent !open ' . shellescape(expand('<cfile>', 1))<CR>]], icons.ui.Window .. " Open in external program" },
		}
	},

	{
		-- Navigation and resizing
		mapping = {
			-- Buffer movement
			["<A-h>"] = { "<CMD>BufferLineCyclePrev<CR>", icons.ui.ChevronLeftCircleOutline .. " Previous buffer", mode = {"n", "i"} },
			["<A-l>"] = { "<CMD>BufferLineCycleNext<CR>", icons.ui.ChevronRightCircleOutline .. " Next buffer", mode = {"n", "i"} },
			["<A-H>"] = { "<CMD>BufferLineMovePrev<CR>", icons.ui.ChevronLeftCircle .. " Move buffer left", mode = {"n", "i"} },
			["<A-L>"] = { "<CMD>BufferLineMoveNext<CR>", icons.ui.ChevronRightCircle .. " Move buffer right", mode = {"n", "i"} },
			-- Window movement
			["<C-w>"] = { icons.ui.Window .. " Manage windows" },
			-- ["<C-w>S"] = { require("utils.windows").swap_window, icons.ui.Swap .. " Swap windows" },
			["<C-h>"] = { "<CMD>wincmd h<CR>", icons.ui.ChevronLeftBoxOutline .. " Go to the left window", mode = {"n", "i"} },
			["<C-j>"] = { "<CMD>wincmd j<CR>", icons.ui.ChevronDownBoxOutline .. " Go to the down window", mode = {"n", "i"} },
			["<C-k>"] = { "<CMD>wincmd k<CR>", icons.ui.ChevronUpBoxOutline .. " Go to the up window", mode = {"n", "i"} },
			["<C-l>"] = { "<CMD>wincmd l<CR>", icons.ui.ChevronRightBoxOutline .. " Go to the right window", mode = {"n", "i"} },
			-- Smooth scrolling
			["<C-y>"] = {
				function() require("neoscroll").scroll(-0.1, true, 100) end,
				icons.ui.ChevronUp .. " Scroll up 10% of window height",
				mode = {"n", "i", "x", "o"},
			},
			["<C-u>"] = {
				function()
					if not require("noice.lsp").scroll(-4) then
						require("neoscroll").scroll(-vim.wo.scroll, true, 350)
					end
				end,
				icons.ui.ChevronDoubleUp .. " Scroll up",
				mode = {"n", "i", "x", "o"},
			},
			["<C-e>"] = {
				function() require("neoscroll").scroll(0.1, true, 100) end,
				icons.ui.ChevronDown .. " Scroll down 10% of window height",
				mode = {"n", "i", "x", "o"},
			},
			["<C-d>"] = {
				function()
					if not require("noice.lsp").scroll(4) then
						require("neoscroll").scroll(vim.wo.scroll, true, 350)
					end
				end,
				icons.ui.ChevronDoubleDown .. " Scroll down",
				mode = {"n", "i", "x", "o"},
			},
			["<PageUp>"] = {
				function()
					require("neoscroll").scroll(-vim.api.nvim_win_get_height(0), true, 550)
				end,
				icons.ui.ChevronTripleUp .. " Page up",
				mode = {"n", "i", "x", "o"},
			},
			["<PageDown>"] = {
				function()
					require("neoscroll").scroll(vim.api.nvim_win_get_height(0), true, 550)
				end,
				icons.ui.ChevronTripleDown .. " Page down",
				mode = {"n", "i", "x", "o"},
			},
			["zz"] = { function() require("neoscroll").zz(200) end, "Centre cursor line in window" },
			["zt"] = { function() require("neoscroll").zt(200) end, "Align cursor line with top of window" },
			["zb"] = { function() require("neoscroll").zb(200) end, "Align cursor line with bottom of window" },
			-- Resize with arrows
			["<C-Up>"] = { "<CMD>resize +2<CR>", icons.ui.ExpandVertical .. " Shrink window vertically" },
			["<C-Down>"] = { "<CMD>resize -2<CR>", icons.ui.ExpandVertical .. " Expand window vertically" },
			["<C-Left>"] = { "<CMD>vertical resize -2<CR>", icons.ui.ExpandHorizontal .. " Shrink window horizontally" },
			["<C-Right>"] = { "<CMD>vertical resize +2<CR>", icons.ui.ExpandHorizontal .. " Expand window horizontally" },
			-- Terminal keys
			["<A-`>"] = { icons.ui.Terminal .. " Toggle terminal" },
			["<C-CR>"] = { [[<CMD>ToggleTermSendCurrentLine<CR>]], icons.ui.Terminal .." Run line in terminal" },
		}
	},

	{
		-- Normal mode editing shortcuts
		mapping = {
			["<A-a>"] = { "ggVG", icons.ui.Cursor .. " Select all" },
			-- Move current line / block with Alt-j/k a la vscode.
			["<A-k>"] = { "<CMD>move .-2<CR>==", icons.ui.MoveUp .. " Move line up" },
			["<A-j>"] = { "<CMD>move .+1<CR>==", icons.ui.MoveDown .. " Move line down" },
			["<A-/>"] = { "<Plug>(comment_toggle_linewise_current)", icons.ui.Comment .. " Toggle comment" },
			-- QuickFix
			["]q"] = { "<CMD>cnext<CR>", icons.diagnostics.Next .. " Next error" },
			["[q"] = { "<CMD>cprev<CR>", icons.diagnostics.Previous .. " Previous error" },
			-- ["<C-q>"] = { "<CMD>call QuickFixToggle()<CR>", "Toggle quickfix" },
			-- Indentation and whitespace formatting
			["<leader>="] = { require("utils.editing").silent_auto_indent, icons.ui.Indent .. " Auto-indent file" },
			["<leader>$"] = { require("utils.editing").remove_trailing_whitespace, icons.ui.WhiteSpace .. " Remove trailing whitespace" },
			["ga"] = { "<Plug>(EasyAlign)", icons.ui.Align .. " Align lines" },
			["gA"] = { "<Plug>(LiveEasyAlign)", icons.ui.Align .. " Align lines with preview" },
			-- Delimiter formatting
			["ys"] = { "<Plug>(nvim-surround-normal)", icons.ui.DelimiterPair .. " Surround" },
			["yss"] = { "<Plug>(nvim-surround-normal-cur)", icons.ui.DelimiterPair .. " Surround line" },
			["yS"] = { "<Plug>(nvim-surround-normal-line)", icons.ui.DelimiterPair .. " Surround on new lines" },
			["ySS"] = { "<Plug>(nvim-surround-normal-cur-line)", icons.ui.DelimiterPair .. " Surround line on new lines" },
			["ds"] = { "<Plug>(nvim-surround-delete)", icons.ui.DelimiterPair .. " Delete delimiter" },
			["cs"] = { "<Plug>(nvim-surround-change)", icons.ui.DelimiterPair .. " Change delimiter" },
			-- Find and replace
			["<F2>"] = {
				function()
					local k = vim.api.nvim_replace_termcodes(":%s/\\<<C-R><C-w>\\>", true, false, true)
					vim.api.nvim_feedkeys(k, "t", false)
				end,
				icons.ui.FindAndReplace .. " Find and replace (whole word)"
			},
			["<F50>"] = {
				function()
					local k = vim.api.nvim_replace_termcodes(":%s/<C-R><C-w>", true, false, true)
					vim.api.nvim_feedkeys(k, "t", false)
				end,
				icons.ui.FindAndReplace .. " Find and replace"
			},
			["<F3>"] = { "<CMD>noh<CR>", icons.ui.Highlight .. " Clear search highlights" },
			["*"] = { [[*<Cmd>lua require('hlslens').start()<CR>]], "Search forwards (whole word)" },
			["#"] = { [[#<Cmd>lua require('hlslens').start()<CR>]], "Search backwards (whole word)" },
			["g*"] = { [[g*<Cmd>lua require('hlslens').start()<CR>]], "Search forwards" },
			["g#"] = { [[g#<Cmd>lua require('hlslens').start()<CR>]], "Search backwards" },
			["n"] = { [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], "Next search result" },
			["N"] = { [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], "Previous search result" },
			-- Hop motions
			-- ['sw'] = { "<CMD>HopWord<CR>", "Hop to word", mode = {'n', 'v', 'o'} },
			-- ['sp'] = { "<CMD>HopPattern<CR>", "Hop to pattern", mode = {'n', 'v'} },
			-- ['sb'] = { "<CMD>HopChar2<CR>", "Hop to bigram", mode = {'n', 'v'} },
			-- ['sl'] = { "<CMD>HopLine<CR>", "Hop to line", mode = {'n', 'v'} },
			-- ['sn'] = { "<CMD>HopNode<CR>", "Hop to treesitter node", mode = {'n', 'v'} },
			-- provided by vim-illuminate
			-- already registered, just putting it here so I know it exists
			["<A-n>"] = { icons.ui.Next .. " Move to next reference" },
			["<A-p>"] = { icons.ui.Previous .. " Move to previous reference" },
		},
	},

	{
		-- insert mode editing shorcuts
		mode = "i",
		mapping = {
			["<A-a>"] = { "<ESC>ggVG", icons.ui.Cursor .. " Select all" },
			["<A-j>"] = { "<Esc>:m .+1<CR>==gi", icons.ui.MoveDown .. " Move line down" },
			["<A-k>"] = { "<Esc>:m .-2<CR>==gi", icons.ui.MoveUp .. " Move line up" },
			["<A-/>"] = { require("utils.editing").comment_in_insert_mode, icons.ui.Comment .. " Toggle comment", noremap = false },
			["<F3>"] = { "<CMD>noh<CR>", "Turn off search highlights" },
			["<A-,>"] = { "<C-D>", icons.ui.IndentDecrease .. " Decrease indentation" },
			["<A-.>"] = { "<C-T>", icons.ui.IndentIncrease .. " Increase indentation" },

			-- Delimiter formatting
			["<A-s>"] = { "<Plug>(nvim-surround-insert)", "Surround" },
			["<A-S>"] = { "<Plug>(nvim-surround-insert-line)", "Surround on new lines" },
		},
	},
	{
		-- visual block mode editing shortcuts
		mode = { "x" },
		mapping = {
			["<A-k>"] = { ":m '<-2<CR>gv-gv", icons.ui.MoveUp .. " Move selection up" },
			["<A-j>"] = { ":m '>+1<CR>gv-gv", icons.ui.MoveDown .. " Move selection down" },
			["<A-/>"] = { "<Plug>(comment_toggle_linewise_visual)gv", icons.ui.Comment .. " Toggle comment" },
			-- Delimiter formatting
			["<A-s>"] = { "<Plug>(nvim-surround-visual)", icons.ui.DelimiterPair .. " Surround" },
			["<A-S>"] = { "<Plug>(nvim-surround-visual-line)", icons.ui.DelimiterPair .. " Surround on new lines" },
			-- Indentation and whitespace formatting
			["<"] = { "<gv", icons.ui.IndentDecrease .. " Decrease indent" },
			[">"] = { ">gv", icons.ui.IndentIncrease .. " Increase indent" },
			["ga"] = { "<Plug>(EasyAlign)", icons.ui.Align .. "Align lines" },
			["gA"] = { "<Plug>(LiveEasyAlign)", icons.ui.Align .. "Align lines with preview" },
			["<F2>"] = {
				function()
					local k = vim.api.nvim_replace_termcodes(":s/", true, false, true)
					vim.api.nvim_feedkeys(k, "t", false)
				end,
				"Find and replace highlighted"
			},
			["<A-CR>"] = { [[:ToggleTermSendVisualSelection<CR>gv]], icons.ui.Terminal .. " Run selection in terminal"},
			["<C-CR>"] = { [[:ToggleTermSendVisualLines<CR>gv]], icons.ui.Terminal .. " Run selected lines in terminal" },
			["<A-i>"] = { "Symbol under cursor" } -- provided by vim-illuminate
		}
	},
	{
		-- operator-pending mode mappings
		mode = "o",
		mapping = {
			["<A-i>"] = { "Symbol under cursor" } -- provided by vim-illuminate
		},
	},
	{
		-- leap motions
		mode = { 'n', 'x', 'o' },
		mapping = {
			['<A-f>'] = { '<Plug>(leap-forward-to)', icons.ui.BoldArrowRight .. " Leap forward to" },
			['<A-S-f>'] = { '<Plug>(leap-backward-to)', icons.ui.BoldArrowLeft .. " Leap backward to" },
			['<A-t>'] = { '<Plug>(leap-forward-till)', icons.ui.BoldArrowRight .. " Leap forward till" },
			['<A-S-t>'] = { '<Plug>(leap-backward-till)', icons.ui.BoldArrowLeft .. " Leap backward till" },
		},
	},

	{
		-- Debugger
		mapping = {
			["<F5>"] = {
				name = icons.debug.Debug .. " Debug",
				["t"] = { require"dap".toggle_breakpoint, "Toggle Breakpoint" },
				["b"] = { require"dap".step_back, "Step Back" },
				["c"] = { require"dap".continue, "Continue" },
				["C"] = { require"dap".run_to_cursor, "Run To Cursor" },
				["d"] = { require"dap".disconnect, "Disconnect" },
				["g"] = { require"dap".session, "Get Session" },
				["i"] = { require"dap".step_into, "Step Into" },
				["o"] = { require"dap".step_over, "Step Over" },
				["u"] = { require"dap".step_out, "Step Out" },
				["p"] = { require"dap".pause, "Pause" },
				["r"] = { require"dap".repl.toggle, "Toggle Repl" },
				["s"] = { require"dap".continue, "Start" },
				["q"] = { require"dap".close, "Quit" },
				["U"] = { function() require"dapui".toggle({reset = true}) end, "Toggle UI" },
			}
		}
	},
	{
		-- Terminal mode mappings
		opts = DefaultOpts {mode = "t"},
		mapping = {
			["<C-k>"] = { [[<CMD>wincmd k<CR>]], icons.ui.ChevronUpBoxOutline .. " Go to the up window" },
			["<C-j>"] = { [[<CMD>wincmd j<CR>]], icons.ui.ChevronDownBoxOutline .. " Go to the down window" },
			["<C-h>"] = { [[<CMD>wincmd h<CR>]], icons.ui.ChevronLeftBoxOutline .. " Go to the left window" },
			["<C-l>"] = { [[<CMD>wincmd l<CR>]], icons.ui.ChevronRightBoxOutline .. " Go to the right window" },
		}
	},
}

-- Don't yank when replacing text
M.other_defaults = {
	{{'v', 'x' }, 'p',
		function()
			if vim.fn.mode() == 'v' then
				vim.api.nvim_feedkeys([["_dhp]], "n", true)
			elseif vim.fn.mode() == 'V' then
				vim.api.nvim_feedkeys([["_dP]], "n", true)
			end
		end,
		opts={noremap = true, silent = true}} -- paste without yanking
}

M.autocmd_keybinds = {
	{
		"FileType",
		{
			desc = "Make q close the window in certain UI buffers",
			group = "q_is_close_keybinding",
			pattern = {
				"qf",
				"help",
				"man",
				"floaterm",
				"lspinfo",
				"null-ls-info",
				"mason",
				"Trouble",
				"alpha",
				-- "lazygit"
			},
			callback = function()
				vim.keymap.set("n", "q", "<cmd>close<cr>", { desc = "Close window", buffer = true })
			end,
		},
	},
	{
		"LspAttach",
		{
			desc = "Shortcut key to change python virtual environment for LSP",
			group = "venv_select",
			callback = function(args)
				if vim.lsp.get_client_by_id( args.data.client_id).name == "pyright" then
					require "nvim-web-devicons"
					local wk = require("which-key")
					wk.register (
						{
							["<leader>Lv"] = {
								name = require "nvim-web-devicons".get_icon_by_filetype("python") ..  " Manage python virtual envs",
								["f"] = { "<CMD>VenvSelect<CR>", icons.ui.Search .. " Find environment" },
								["i"] = { "<CMD>VenvSelectCurrent<CR>", icons.ui.ChevronRightBoxOutline .. " Current environment info" },
								["r"] = { "<CMD>VenvSelectCached<CR>", icons.ui.History .. " Initialise last used environment" },
							}
						},
						{
							buffer = 0,
							noremap = true,
							silent = true
						}
					)
				end
			end
		}
	},
	{
		-- escape from terminal mode in toggleterm
		"TermOpen",
		{
			group = "escape_in_toggleterm",
			pattern = "term://*toggleterm#*",
			callback = function()
				vim.keymap.set('t', "<Esc>", [[<C-\><C-n>]], {desc = "Normal mode", buffer = true})
			end,
		}
	},
	{
		-- LSp keymaps
		"LspAttach",
		{
			group = "lsp_keybindings",
			callback = function(args)
				local opts = {buffer = args.buf}
				local bufmap = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, {desc = desc})) end
				local client_capabilities = vim.lsp.get_client_by_id(args.data.client_id).server_capabilities

				bufmap('n', '<leader>Li', "<CMD>LspInfo<CR>", icons.diagnostics.Information .. " LSP clients info" )
				bufmap('n', '<leader>Lr', "<CMD>LspRestart<CR>", icons.ui.Reload .. " Restart clients attached to this buffer")
				bufmap('n', '<leader>Lx', "<CMD>LspStop<CR>", icons.ui.BoldClose .. " Kill clients attached to this buffer")
				bufmap('n', '<leader>Ls', "<CMD>LspStart<CR>", icons.ui.Play .. " Start clients for this buffer")
				if client_capabilities.documentFormattingProvider then
					bufmap('n', '<leader>+', function() require("utils.editing").lsp_format() end, icons.ui.Indent .. " Auto-format file")
				end
				if client_capabilities.documentRangeFormattingProvider then
					bufmap('x', '+', function() require("utils.editing").lsp_format() end, icons.ui.Indent .. " Auto-format file")
				end
				if client_capabilities.renameProvider then
					bufmap('n', '<F51>', vim.lsp.buf.rename, icons.syntax.Object .. " Rename symbol")
				end
				if client_capabilities.definitionProvider then
					bufmap('n', 'gd', vim.lsp.buf.definition, "Go to definition")
				end
				if client_capabilities.declarationProvider then
					bufmap('n', 'gD', vim.lsp.buf.declaration, "Go to declaration")
				end
				if client_capabilities.signatureHelpProvider then
					bufmap('n', 'gs', vim.lsp.buf.signature_help, "Signature help")
					bufmap('i', '<C-s>', vim.lsp.buf.signature_help, "Signature help")
				end
				if client_capabilities.hoverProvider then
					bufmap('n', 'gk', vim.lsp.buf.hover, "Hover symbol")
					bufmap('i', '<C-h>', vim.lsp.buf.hover, "Hover symbol")
				end
				if client_capabilities.referencesProvider then
					bufmap('n', 'gr', vim.lsp.buf.references, "List references")
				end
				if client_capabilities.codeActionProvider then
					bufmap('n', '<F4>', vim.lsp.buf.code_action, "Code actions")
					bufmap('x', '<F4>', vim.lsp.buf.code_action, "Code actions")
				end
				bufmap('n', 'gl',
					function()
						vim.diagnostic.open_float(nil, {
							bufnr = args.buf
						})
					end
					, "Hover diagnostic")
				bufmap('n', '[d', vim.diagnostic.goto_prev, "Previous diagnostic")
				bufmap('n', ']d', vim.diagnostic.goto_next, "Next diagnostic")
			end
		}
	}
}

function M.load_defaults()
	local wk = require("which-key")
	for _,v in ipairs(M.which_key_defaults) do
		wk.register(v.mapping, v.opts or DefaultOpts{mode = v.mode or "n" })
	end
	for _, mapping in pairs(M.other_defaults) do
		vim.keymap.set(unpack(mapping))
	end
	require("autocmds").define_autocmds(M.autocmd_keybinds)
end

--
-- -- navigation
-- ["<A-Up>"] = "<C-\\><C-N><C-w>k",
-- ["<A-Down>"] = "<C-\\><C-N><C-w>j",
-- ["<A-Left>"] = "<C-\\><C-N><C-w>h",
-- ["<A-Right>"] = "<C-\\><C-N><C-w>l",
-- },
--
--
-- term_mode = {
-- -- Terminal window navigation
-- ["<C-h>"] = "<C-\\><C-N><C-w>h",
-- ["<C-j>"] = "<C-\\><C-N><C-w>j",
-- ["<C-k>"] = "<C-\\><C-N><C-w>k",
-- ["<C-l>"] = "<C-\\><C-N><C-w>l",
-- },
--
-- -- ["p"] = ""0p",
-- -- ["P"] = ""0P",
--
-- command_mode = {
-- -- navigate tab completion with <c-j> and <c-k>
-- -- runs conditionally
-- ["<C-j>"] = { "pumvisible() ? "\\<C-n>" <CMD> "\\<C-j>"", { expr = true, noremap = true } },
-- ["<C-k>"] = { "pumvisible() ? "\\<C-p>" <CMD> "\\<C-k>"", { expr = true, noremap = true } },
-- },
return M
