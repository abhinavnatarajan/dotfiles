local M = {}

local DefaultOpts = require("utils").prototype({
	buffer = nil,  -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
	expr = false,
})
local icons = require("icons")

M.which_key_defaults = {
	{
		-- "File menu" shortcuts
		mapping = {
			["<Leader>"] = {
				name = icons.ui.Files .. " Leader shortcuts",
				["L"] = {
					name = icons.ui.Lightbulb .. " LSP",
					["i"] = { "<CMD>LspInfo<CR>", icons.diagnostics.Information .. " LSP clients info" },
					["r"] = { "<CMD>LspRestart<CR>", icons.ui.Reload .. " Restart clients attached to this buffer" },
					["x"] = { "<CMD>LspStop<CR>", icons.ui.BoldClose .. " Kill clients attached to this buffer" },
					["s"] = { "<CMD>LspStart<CR>", icons.ui.Play .. " Start clients for this buffer" },
				},
				["`"] = {
					name = icons.ui.Terminal .. " Terminals",
				},
				["w"] = {
					[[<CMD>lua require("telescope_custom_pickers").check_save_as()<CR>]],
					icons.ui.Save .. " Save",
				},
				["W"] = { "<CMD>wa!<CR>", icons.ui.SaveAll .. " Save all" },
				["q"] = { "<CMD>confirm q<CR>", icons.ui.BoldClose .. " Close window" },
				["Q"] = { "<CMD>qa!<CR>", icons.ui.BoldClose .. " Quit" },
				["%"] = { "<CMD>cd %:p:h<CR>", icons.ui.FolderActive .. " Set working directory from active buffer" },
				["-"] = { "<CMD>cd ..<CR>", icons.ui.FolderUp .. " Go up one directory" },
				["h"] = { "<CMD>Telescope help_tags<CR>", icons.ui.FindFile .. " Search in help topics" },
				["C"] = { "q:", icons.ui.Terminal .. " Command history" },
				["T"] = { "<CMD>Telescope<CR>", icons.ui.Telescope .. " Telescope" },
				["s"] = {
					name = icons.ui.Gear .. " Settings",
					["f"] = {
						[[<CMD>lua require("telescope_custom_pickers").config()<CR>]],
						icons.ui.ConfigFolder .. " Browse config files",
					},
					["i"] = { require("utils.editing").choose_global_indent, icons.ui.Indent .. " Set indentation" },
				},
				["f"] = {
					name = icons.ui.Files .. " Files",
					["w"] = {
						[[<CMD>lua require("telescope_custom_pickers").save_as()<CR>]],
						icons.ui.SaveAs .. " Save as",
					},
					-- search for filenames
					["f"] = {
						[[<CMD>lua require("telescope.builtin").find_files()<CR>]],
						icons.ui.FindFile .. " Fzf files",
					},
					["d"] = { "<CMD>Telescope file_browser<CR>", icons.ui.FolderOpen .. " Browse files" },
					["r"] = { [[<CMD>Telescope oldfiles<CR>]], icons.ui.History .. " Recent files" },
					--  search for strings
					["g"] = {
						function()
							require("telescope.builtin").live_grep({
								search_dirs = { vim.fn.expand("%:p") },
								path_display = "hidden",
								prompt_title = "Grep string (buffer)",
								additional_args = { "--smart-case" },
							})
						end,
						icons.ui.FindText .. " Grep string (buffer)",
					},

					["s"] = {
						function()
							require("telescope.builtin").current_buffer_fuzzy_find({
								prompt_title = "Fzf string (buffer)",
							})
						end,
						icons.ui.FindText .. " Fzf string (buffer)",
					},

					["G"] = {
						function()
							require("telescope.builtin").live_grep({
								prompt_title = "Grep string (cwd)",
								additional_args = { "--smart-case" },
							})
						end,
						icons.ui.FindText .. " Grep string (cwd)",
					},

					["S"] = {
						function()
							require("telescope.builtin").grep_string({
								shorten_path = true,
								word_match = "-w",
								only_sort_text = true,
								search = "",
								prompt_title = "Fzf string (cwd)",
							})
						end,
						icons.ui.FindText .. " Fzf string (cwd)",
					},

					["t"] = { [[<CMD>Telescope filetypes<CR>]], icons.syntax.Text .. " Set filetype" },
					["i"] = { require("utils.editing").choose_buffer_indent, icons.ui.Indent .. " Set indentation" },
					["n"] = {
						[[<CMD>lua require("utils.windows").edit_new_file_handler()<CR>]],
						icons.ui.NewFile .. " New file",
					},
					["m"] = {
						require("utils.editing").choose_file_newline,
						icons.ui.ReturnCharacter .. " Set newline format",
					},
				},
				["P"] = {
					name = icons.ui.ToolBox .. " Plugins",
					["m"] = { "<CMD>Lazy home<CR>", icons.ui.Configure .. " Manage plugins" },
					["f"] = { "<CMD>Telescope lazy<CR>", icons.ui.FolderOpen .. " Explore plugin files" },
				},
				["b"] = {
					name = icons.ui.Files .. " Buffers",
					["f"] = {
						[[<CMD> lua require("telescope_custom_pickers").buffers()<CR>]],
						icons.ui.FindFile .. " Find buffer",
					},
				},
				["g"] = {
					name = icons.git.Git .. " Git",
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
							vim.ui.input({ prompt = "Go to tab:" }, function(input)
								vim.cmd("silent! tabnext" .. input)
							end)
						end,
						"Jump to tab",
					},
				},
				["u"] = { "<CMD>Telescope undo<CR>", icons.ui.Undo .. " Undo history" },
			},
			["<Esc>"] = { [[<C-\><C-n>]], "Normal mode", mode = "t" },
			["gx"] = {
				[[:exe 'silent !open ' . shellescape(expand('<cfile>', 1))<CR>]],
				icons.ui.Window .. " Open in external program",
			},
		},
	},

	{
		-- Navigation and resizing
		mapping = {
			-- Window movement
			["<C-w>"]     = { name = icons.ui.Window .. " Manage windows" },
			-- ["<C-w>S"] = { require("utils.windows").swap_window, icons.ui.Swap .. " Swap windows" },
			["<C-w>h"]    = {
				"<CMD>wincmd h<CR>",
				icons.ui.ChevronLeftBoxOutline .. " Go to the left window",
				mode = { "n", "i" },
			},
			["<C-w>j"]    = {
				"<CMD>wincmd j<CR>",
				icons.ui.ChevronDownBoxOutline .. " Go to the down window",
				mode = { "n", "i" },
			},
			["<C-w>k"]    = {
				"<CMD>wincmd k<CR>",
				icons.ui.ChevronUpBoxOutline .. " Go to the up window",
				mode = { "n", "i" },
			},
			["<C-w>l"]    = {
				"<CMD>wincmd l<CR>",
				icons.ui.ChevronRightBoxOutline .. " Go to the right window",
				mode = { "n", "i" },
			},
			-- Resize with arrows
			["<C-Up>"]    = { "<CMD>resize +2<CR>", icons.ui.ExpandVertical .. " Shrink window vertically" },
			["<C-Down>"]  = { "<CMD>resize -2<CR>", icons.ui.ExpandVertical .. " Expand window vertically" },
			["<C-Left>"]  = { "<CMD>vertical resize -2<CR>", icons.ui.ExpandHorizontal .. " Shrink window horizontally" },
			["<C-Right>"] = {
				"<CMD>vertical resize +2<CR>",
				icons.ui.ExpandHorizontal .. " Expand window horizontally",
			},
		},
	},
	{
		-- Normal mode editing shortcuts
		mapping = {
			["<A-a>"]     = { "ggVG", icons.ui.Cursor .. " Select all" },
			-- Move current line / block with Alt-j/k a la vscode.
			["<A-k>"]     = { "<CMD>move .-2<CR>==", icons.ui.MoveUp .. " Move line up" },
			["<A-j>"]     = { "<CMD>move .+1<CR>==", icons.ui.MoveDown .. " Move line down" },
			-- Indentation and whitespace formatting
			["<leader>="] = { require("utils.editing").silent_auto_indent, icons.ui.Indent .. " Auto-indent file" },
			["<leader>$"] = {
				require("utils.editing").remove_trailing_whitespace,
				icons.ui.WhiteSpace .. " Remove trailing whitespace",
			},
			-- Word info
			["g<C-g>"]    = { icons.ui.Note .. " Count lines, words, and characters" },
		},
	},
	{
		-- insert mode editing shorcuts
		mode = "i",
		mapping = {
			["<A-a>"] = { "<ESC>ggVG", icons.ui.Cursor .. " Select all" },
			["<A-j>"] = { "<Esc>:m .+1<CR>==gi", icons.ui.MoveDown .. " Move line down" },
			["<A-k>"] = { "<Esc>:m .-2<CR>==gi", icons.ui.MoveUp .. " Move line up" },
			["<F3>"]  = { "<CMD>noh<CR>", "Turn off search highlights" },
			["<A-,>"] = { "<C-D>", icons.ui.IndentDecrease .. " Decrease indentation" },
			["<A-.>"] = { "<C-T>", icons.ui.IndentIncrease .. " Increase indentation" },
			["<C-j>"] = { "<Down>", "Move cursor down" },
			["<C-k>"] = { "<Up>", "Move cursor up" },
			["<C-h>"] = { "<Left>", "Move cursor left" },
			["<C-l>"] = { "<Right>", "Move cursor right" },
		},
	},
	{
		-- visual block mode editing shortcuts
		mode = { "x" },
		mapping = {
			["<A-k>"]  = { ":m '<-2<CR>gv-gv", icons.ui.MoveUp .. " Move selection up" },
			["<A-j>"]  = { ":m '>+1<CR>gv-gv", icons.ui.MoveDown .. " Move selection down" },
			-- Indentation and whitespace formatting
			["<"]      = { "<gv", icons.ui.IndentDecrease .. " Decrease indent" },
			[">"]      = { ">gv", icons.ui.IndentIncrease .. " Increase indent" },
			["g<C-g>"] = { icons.ui.Note .. " Count highlighted lines, words, and characters" },
		},
	},
	-- Find and replace (see also LSP keybinds)
	{
		mapping = {
			["<F2>"] = {
				function()
					local k = vim.api.nvim_replace_termcodes(":%s/<C-R><C-w>", true, false, true)
					vim.api.nvim_feedkeys(k, "t", false)
				end,
				icons.ui.FindAndReplace .. " Find and replace",
			},
			["<F14>"] = {
				function()
					local k = vim.api.nvim_replace_termcodes(":%s/\\<<C-R><C-w>\\>", true, false, true)
					vim.api.nvim_feedkeys(k, "t", false)
				end,
				icons.ui.FindAndReplace .. " Find and replace (whole word)",
			},
		},
	},
	{
		mode = { "x" },
		mapping = {
			["<F2>"] = {
				function()
					local k = vim.api.nvim_replace_termcodes(":s/", true, false, true)
					vim.api.nvim_feedkeys(k, "t", false)
				end,
				"Find and replace highlighted",
			},
		},
	},
	-- searching
	{
		mode = { "n", "x", "o" },
		mapping = {
			["*"]    = { "Search forwards (whole word)" },
			["#"]    = { "Search backwards (whole word)" },
			["g*"]   = { "Search forwards" },
			["g#"]   = { "Search backwards" },
			["n"]    = {
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR>]],
				"Next search result",
			},
			["N"]    = {
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR>]],
				"Previous search result",
			},
			["<F3>"] = { "<CMD>noh<CR>", icons.ui.Highlight .. " Clear search highlights", mode = { "n", "i" } },
		},
	},
	{
		-- Debugger
		mapping = {
			["<F5>"] = {
				name = icons.debug.Debug .. " Debug",
				["t"] = { require("dap").toggle_breakpoint, "Toggle Breakpoint" },
				["b"] = { require("dap").step_back, "Step Back" },
				["c"] = { require("dap").continue, "Continue" },
				["C"] = { require("dap").run_to_cursor, "Run To Cursor" },
				["d"] = { require("dap").disconnect, "Disconnect" },
				["g"] = { require("dap").session, "Get Session" },
				["i"] = { require("dap").step_into, "Step Into" },
				["o"] = { require("dap").step_over, "Step Over" },
				["u"] = { require("dap").step_out, "Step Out" },
				["p"] = { require("dap").pause, "Pause" },
				["r"] = { require("dap").repl.toggle, "Toggle Repl" },
				["s"] = { require("dap").continue, "Start" },
				["q"] = { require("dap").close, "Quit" },
				["U"] = {
					function()
						require("dapui").toggle({ reset = true })
					end,
					"Toggle UI",
				},
			},
		},
	},
}

-- Don't yank when replacing text
M.other_defaults = {
	{
		"x",
		"p",
		function()
			if vim.fn.mode() == "v" then -- note that 'v' here is charwise visual, not visual + select
				vim.api.nvim_feedkeys([["_dhp]], "n", true)
			elseif vim.fn.mode() == "V" then
				vim.api.nvim_feedkeys([["_dP]], "n", true)
			end
		end,
		{ noremap = true, silent = true },
	}, -- paste without yanking
	{
		"x", "c", [["_c]], { noremap = true, silent = true }
	} -- correct without yanking
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
		-- LSP keymaps
		"LspAttach",
		{
			group = "lsp_keybindings",
			callback = function(args)
				local opts = { buffer = args.buf }
				local bufmap = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
				end
				local client_capabilities = vim.lsp.get_client_by_id(args.data.client_id).server_capabilities

				if client_capabilities.renameProvider then
					bufmap("n", "<F50>", vim.lsp.buf.rename, icons.syntax.Object .. " Rename symbol")
				end
				if client_capabilities.definitionProvider then
					bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
				end
				if client_capabilities.declarationProvider then
					bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				end
				if client_capabilities.signatureHelpProvider then
					bufmap("n", "gs", vim.lsp.buf.signature_help, "Signature help")
					bufmap("i", "<C-.>", vim.lsp.buf.signature_help, "Signature help")
				end
				if client_capabilities.hoverProvider then
					bufmap("n", "gK", vim.lsp.buf.hover, "Hover symbol")
					bufmap("i", "<C-,>", vim.lsp.buf.hover, "Hover symbol")
				end
				if client_capabilities.referencesProvider then
					bufmap("n", "gr", vim.lsp.buf.references, "List references")
				end
				if client_capabilities.codeActionProvider then
					bufmap("n", "<F4>", vim.lsp.buf.code_action, "Code actions")
					bufmap("x", "<F4>", vim.lsp.buf.code_action, "Code actions")
				end
				bufmap("n", "gl", function()
					vim.diagnostic.open_float(nil, {
						bufnr = args.buf,
					})
				end, "Hover diagnostic")
				bufmap("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
				bufmap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
			end,
		},
	},
}

function M.load_defaults()
	local wk = require("which-key")
	for _, v in ipairs(M.which_key_defaults) do
		wk.register(v.mapping, v.opts or DefaultOpts({ mode = v.mode or "n" }))
	end
	for _, mapping in pairs(M.other_defaults) do
		vim.keymap.set(unpack(mapping))
	end
	require("autocmds").define_autocmds(M.autocmd_keybinds)
end

return M
