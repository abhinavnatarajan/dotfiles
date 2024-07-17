local icons = require("icons")
return {
	{
		"kdheepak/lazygit.nvim",
		-- this plugin is not versioned
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- "nvim-telescope/telescope.nvim"
		},
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		keys = {
			{ "<leader>gg", function() require("lazygit").lazygit() end, desc = require("icons").git.Branch .. " LazyGit" },
		},
		init = function()
			vim.list_extend(require('config.keybinds').which_key_defaults,
				{ { "<Leader>g", group = require('icons').git.Git .. " Git" } })
		end,
		config = function()
			-- require("telescope").load_extension("lazygit")
			vim.g.lazygit_floating_window_winblend = 5 -- transparency of floating window
			vim.g.lazygit_floating_window_scaling_factor = 1.0 -- scaling factor for floating window
			vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- customize lazygit popup window border characters
			vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
			vim.g.lazygit_use_neovim_remote = 0 -- fallback to 0 if neovim-remote is not installed
			vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
			-- vim.g.lazygit_config_file_path = '' -- custom config file path
			-- -- OR
			-- vim.g.lazygit_config_file_path = {} -- table of custom config file paths
			require('autocmds').define_autocmd(
				"FileType",
				{
					desc = "Disable escape key in lazygit",
					group = "disable_escape_in_lazygit",
					pattern = { "lazygit" },
					callback = function()
						vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = 0 })
					end,
				}
			)
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "User FileReadPre", -- plugin attaches itself on BufReadPost
		version = "*",
		opts = {
			signs = {
				add          = { hl = "GitSignsAdd", text = "┇", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
				change       = { hl = "GitSignsChange", text = "┇", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
				delete       = { hl = "GitSignsDelete", text = "┗", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
				topdelete    = { hl = "GitSignsDelete", text = "┏", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
				changedelete = {
					hl = "GitSignsChange",
					text = "~",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
				untracked    = { hl = "GitSignsDelete", text = "┇", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false,  -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 0,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			-- sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			trouble = false, -- use trouble.nvim for qflist
			diff_opts = {
				algorithm = "histogram",
				internal = false,
			},
			base = nil, -- diff against index by default
			on_attach = function()
				vim.keymap.set(
					"n", "<leader>gs",
					function()
						require("gitsigns").stage_hunk()
					end,
					{ desc = "Stage hunk" }
				)
				vim.keymap.set(
					"n", "<leader>gx",
					function()
						require("gitsigns").reset_hunk()
					end,
					{ desc = icons.ui.Reload .. " Reset hunk" }
				)
				vim.keymap.set(
					"n", "<leader>gu",
					function()
						require("gitsigns").undo_stage_hunk()
					end,
					{ desc = icons.ui.Undo .. " Undo stage hunk" }
				)
				vim.keymap.set(
					"n", "<leader>gK",
					function()
						require("gitsigns").preview_hunk()
					end,
					{ desc = icons.ui.Hover .. " Hunk preview (hover)" }
				)
				vim.keymap.set(
					"n", "<leader>gp",
					function()
						require("gitsigns").preview_hunk_inline()
					end,
					{ desc = icons.ui.Preview .. " Hunk preview (inline)" }
				)
				vim.keymap.set(
					"n", "<leader>gS",
					function()
						require("gitsigns").stage_buffer()
					end,
					{ desc = "Stage buffer" }
				)
				vim.keymap.set(
					"n", "<leader>gX",
					function()
						require("gitsigns").reset_buffer()
					end,
					{ desc = icons.ui.Reload .. " Reset buffer" }
				)
				vim.keymap.set(
					"n", "<leader>gq",
					function()
						require("gitsigns").setqflist()
					end,
					{ desc = icons.git.Diff .. " Send hunks to qflist" }
				)
				vim.keymap.set(
					"n", "<leader>gt",
					function()
						require("gitsigns").toggle_deleted()
					end,
					{ desc = "Toggle deleted" }
				)
				vim.keymap.set("n", "<leader>gb",
					function() require('gitsigns').toggle_current_line_blame() end,
					{ desc = icons.ui.Person .. " Line blame" })
				vim.keymap.set("n", "]g", function() require("gitsigns").next_hunk() end, { desc = "Next hunk" })
				vim.keymap.set("n", "[g", function() require("gitsigns").prev_hunk() end, { desc = "Previous hunk" })
				-- keymaps to activate diffview.nvim
				-- we set them here so that they are only activated in a git repository
				vim.keymap.set(
					"n",
					"<leader>gd",
					"<CMD>DiffviewOpen<CR>",
					{ desc = icons.git.Diff .. " Open Diffview" }
				)
				vim.keymap.set(
					"n",
					"<leader>gr",
					"<CMD>DiffviewFileHistory<CR>",
					{ desc = icons.ui.History .. " Diffview of file history" }
				)
			end
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd    = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffvewFocusFiles", "DiffviewRefresh", "DiffviewLog" },
		config = function()
			local actions = require("diffview.config").actions
			require("diffview").setup {
				diff_binaries = false, -- Show diffs for binaries
				enhanced_diff_hl = false, -- See |diffview-config-enhanced_diff_hl|
				git_cmd = { "git" },  -- The git executable followed by default args.
				hg_cmd = { "hg" },    -- The hg executable followed by default args.
				use_icons = true,     -- Requires nvim-web-devicons
				show_help_hints = true, -- Show hints for how to open the help panel
				watch_index = true,   -- Update views and index buffers when the git index changes.
				icons = {             -- Only applies when use_icons is true.
					folder_closed = icons.ui.Folder,
					folder_open = icons.ui.FolderOpen,
				},
				signs = {
					fold_closed = "",
					fold_open = "",
					done = "✓",
				},
				view = {
					-- Configure the layout and behavior of different types of views.
					-- Available layouts:
					--  'diff1_plain'
					--    |'diff2_horizontal'
					--    |'diff2_vertical'
					--    |'diff3_horizontal'
					--    |'diff3_vertical'
					--    |'diff3_mixed'
					--    |'diff4_mixed'
					-- For more info, see |diffview-config-view.x.layout|.
					default = {
						-- Config for changed files, and staged files in diff views.
						layout = "diff2_horizontal",
						disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
						winbar_info = false,   -- See |diffview-config-view.x.winbar_info|
					},
					merge_tool = {
						-- Config for conflicted files in diff views during a merge or rebase.
						layout = "diff3_horizontal",
						disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
						winbar_info = true,   -- See |diffview-config-view.x.winbar_info|
					},
					file_history = {
						-- Config for changed files in file history views.
						layout = "diff2_horizontal",
						disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
						winbar_info = false,   -- See |diffview-config-view.x.winbar_info|
					},
				},
				file_panel = {
					listing_style = "tree",      -- One of 'list' or 'tree'
					tree_options = {             -- Only applies when listing_style is 'tree'
						flatten_dirs = true,       -- Flatten dirs that only contain one single dir
						folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
					},
					win_config = {               -- See |diffview-config-win_config|
						position = "left",
						width = 35,
						win_opts = {},
					},
				},
				file_history_panel = {
					log_options = { -- See |diffview-config-log_options|
						git = {
							single_file = {
								diff_merges = "combined",
							},
							multi_file = {
								diff_merges = "first-parent",
							},
						},
						hg = {
							single_file = {},
							multi_file = {},
						},
					},
					win_config = { -- See |diffview-config-win_config|
						position = "bottom",
						height = 16,
						win_opts = {},
					},
				},
				commit_log_panel = {
					win_config = {}, -- See |diffview-config-win_config|
				},
				default_args = { -- Default args prepended to the arg-list for the listed commands
					DiffviewOpen = {},
					DiffviewFileHistory = {},
				},
				hooks = {},           -- See |diffview-config-hooks|
				keymaps = {
					disable_defaults = true, -- Disable the default keymaps
					view = {
						-- The `view` bindings are active in the diff buffers, only when the current
						-- tabpage is a Diffview.
						{ "n", "<tab>",          actions.select_next_entry,             { desc = "Open the diff for the next file" } },
						{ "n", "<s-tab>",        actions.select_prev_entry,             { desc = "Open the diff for the previous file" } },
						{ "n", "gf",             actions.goto_file_edit,                { desc = "Open the file in the previous tabpage" } },
						{ "n", "<C-w><C-f>",     actions.goto_file_split,               { desc = "Open the file in a new split" } },
						{ "n", "<C-w>gf",        actions.goto_file_tab,                 { desc = "Open the file in a new tabpage" } },
						{ "n", "<leader>e",      actions.focus_files,                   { desc = "Bring focus to the file panel" } },
						{ "n", "<leader>b",      actions.toggle_files,                  { desc = "Toggle the file panel." } },
						{ "n", "g<C-x>",         actions.cycle_layout,                  { desc = "Cycle through available layouts." } },
						{ "n", "[x",             actions.prev_conflict,                 { desc = "In the merge-tool: jump to the previous conflict" } },
						{ "n", "]x",             actions.next_conflict,                 { desc = "In the merge-tool: jump to the next conflict" } },
						{ "n", "<localleader>o", actions.conflict_choose("ours"),       { desc = "Choose the OURS version of a conflict" } },
						{ "n", "<localleader>t", actions.conflict_choose("theirs"),     { desc = "Choose the THEIRS version of a conflict" } },
						{ "n", "<localleader>b", actions.conflict_choose("base"),       { desc = "Choose the BASE version of a conflict" } },
						{ "n", "<localleader>a", actions.conflict_choose("all"),        { desc = "Choose all the versions of a conflict" } },
						{ "n", "dlocalx",        actions.conflict_choose("none"),       { desc = "Delete the conflict region" } },
						{ "n", "<localleader>O", actions.conflict_choose_all("ours"),   { desc = "Choose the OURS version of a conflict for the whole file" } },
						{ "n", "<localleader>T", actions.conflict_choose_all("theirs"), { desc = "Choose the THEIRS version of a conflict for the whole file" } },
						{ "n", "<localleader>B", actions.conflict_choose_all("base"),   { desc = "Choose the BASE version of a conflict for the whole file" } },
						{ "n", "<localleader>A", actions.conflict_choose_all("all"),    { desc = "Choose all the versions of a conflict for the whole file" } },
						{ "n", "dX",             actions.conflict_choose_all("none"),   { desc = "Delete the conflict region for the whole file" } },
					},
					diff1 = {
						-- Mappings in single window diff layouts
						{ "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
					},
					diff2 = {
						-- Mappings in 2-way diff layouts
						{ "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
					},
					diff3 = {
						-- Mappings in 3-way diff layouts
						{ { "n", "x" }, "2do", actions.diffget("ours"),           { desc = "Obtain the diff hunk from the OURS version of the file" } },
						{ { "n", "x" }, "3do", actions.diffget("theirs"),         { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
						{ "n",          "g?",  actions.help({ "view", "diff3" }), { desc = "Open the help panel" } },
					},
					diff4 = {
						-- Mappings in 4-way diff layouts
						{ { "n", "x" }, "1do", actions.diffget("base"),           { desc = "Obtain the diff hunk from the BASE version of the file" } },
						{ { "n", "x" }, "2do", actions.diffget("ours"),           { desc = "Obtain the diff hunk from the OURS version of the file" } },
						{ { "n", "x" }, "3do", actions.diffget("theirs"),         { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
						{ "n",          "g?",  actions.help({ "view", "diff4" }), { desc = "Open the help panel" } },
					},
					file_panel = {
						{ "n", "j",               actions.next_entry,                    { desc = "Bring the cursor to the next file entry" } },
						{ "n", "<down>",          actions.next_entry,                    { desc = "Bring the cursor to the next file entry" } },
						{ "n", "k",               actions.prev_entry,                    { desc = "Bring the cursor to the previous file entry" } },
						{ "n", "<up>",            actions.prev_entry,                    { desc = "Bring the cursor to the previous file entry" } },
						{ "n", "<cr>",            actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
						{ "n", "o",               actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
						{ "n", "l",               actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
						{ "n", "<2-LeftMouse>",   actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
						{ "n", "-",               actions.toggle_stage_entry,            { desc = "Stage / unstage the selected entry" } },
						{ "n", "s",               actions.toggle_stage_entry,            { desc = "Stage / unstage the selected entry" } },
						{ "n", "S",               actions.stage_all,                     { desc = "Stage all entries" } },
						{ "n", "U",               actions.unstage_all,                   { desc = "Unstage all entries" } },
						{ "n", "X",               actions.restore_entry,                 { desc = "Restore entry to the state on the left side" } },
						{ "n", "L",               actions.open_commit_log,               { desc = "Open the commit log panel" } },
						{ "n", "zo",              actions.open_fold,                     { desc = "Expand fold" } },
						{ "n", "h",               actions.close_fold,                    { desc = "Collapse fold" } },
						{ "n", "zc",              actions.close_fold,                    { desc = "Collapse fold" } },
						{ "n", "za",              actions.toggle_fold,                   { desc = "Toggle fold" } },
						{ "n", "zR",              actions.open_all_folds,                { desc = "Expand all folds" } },
						{ "n", "zM",              actions.close_all_folds,               { desc = "Collapse all folds" } },
						{ "n", "<c-b>",           actions.scroll_view(-0.25),            { desc = "Scroll the view up" } },
						{ "n", "<c-f>",           actions.scroll_view(0.25),             { desc = "Scroll the view down" } },
						{ "n", "<tab>",           actions.select_next_entry,             { desc = "Open the diff for the next file" } },
						{ "n", "<s-tab>",         actions.select_prev_entry,             { desc = "Open the diff for the previous file" } },
						{ "n", "gf",              actions.goto_file_edit,                { desc = "Open the file in the previous tabpage" } },
						{ "n", "<C-w><C-f>",      actions.goto_file_split,               { desc = "Open the file in a new split" } },
						{ "n", "<C-w>gf",         actions.goto_file_tab,                 { desc = "Open the file in a new tabpage" } },
						{ "n", "i",               actions.listing_style,                 { desc = "Toggle between 'list' and 'tree' views" } },
						{ "n", "f",               actions.toggle_flatten_dirs,           { desc = "Flatten empty subdirectories in tree listing style" } },
						{ "n", "R",               actions.refresh_files,                 { desc = "Update stats and entries in the file list" } },
						{ "n", "<leader>e",       actions.focus_files,                   { desc = "Bring focus to the file panel" } },
						{ "n", "<leader>b",       actions.toggle_files,                  { desc = "Toggle the file panel" } },
						{ "n", "g<C-x>",          actions.cycle_layout,                  { desc = "Cycle available layouts" } },
						{ "n", "[x",              actions.prev_conflict,                 { desc = "Go to the previous conflict" } },
						{ "n", "]x",              actions.next_conflict,                 { desc = "Go to the next conflict" } },
						{ "n", "g?",              actions.help("file_panel"),            { desc = "Open the help panel" } },
						{ "n", "<localleader>cO", actions.conflict_choose_all("ours"),   { desc = "Choose the OURS version of a conflict for the whole file" } },
						{ "n", "<localleader>cT", actions.conflict_choose_all("theirs"), { desc = "Choose the THEIRS version of a conflict for the whole file" } },
						{ "n", "<localleader>cB", actions.conflict_choose_all("base"),   { desc = "Choose the BASE version of a conflict for the whole file" } },
						{ "n", "<localleader>cA", actions.conflict_choose_all("all"),    { desc = "Choose all the versions of a conflict for the whole file" } },
						{ "n", "dX",              actions.conflict_choose_all("none"),   { desc = "Delete the conflict region for the whole file" } },
					},
					file_history_panel = {
						{ "n", "g!",             actions.options,                    { desc = "Open the option panel" } },
						{ "n", "<C-A-d>",        actions.open_in_diffview,           { desc = "Open the entry under the cursor in a diffview" } },
						{ "n", "y",              actions.copy_hash,                  { desc = "Copy the commit hash of the entry under the cursor" } },
						{ "n", "L",              actions.open_commit_log,            { desc = "Show commit details" } },
						{ "n", "X",              actions.restore_entry,              { desc = "Restore file to the state from the selected entry" } },
						{ "n", "zr",             actions.open_fold,                  { desc = "Expand fold" } },
						{ "n", "zo",             actions.open_fold,                  { desc = "Expand fold" } },
						{ "n", "zm",             actions.close_fold,                 { desc = "Collapse fold" } },
						{ "n", "zc",             actions.close_fold,                 { desc = "Collapse fold" } },
						{ "n", "h",              actions.close_fold,                 { desc = "Collapse fold" } },
						{ "n", "za",             actions.toggle_fold,                { desc = "Toggle fold" } },
						{ "n", "zR",             actions.open_all_folds,             { desc = "Expand all folds" } },
						{ "n", "zM",             actions.close_all_folds,            { desc = "Collapse all folds" } },
						{ "n", "j",              actions.next_entry,                 { desc = "Bring the cursor to the next file entry" } },
						{ "n", "<down>",         actions.next_entry,                 { desc = "Bring the cursor to the next file entry" } },
						{ "n", "k",              actions.prev_entry,                 { desc = "Bring the cursor to the previous file entry" } },
						{ "n", "<up>",           actions.prev_entry,                 { desc = "Bring the cursor to the previous file entry" } },
						{ "n", "<cr>",           actions.select_entry,               { desc = "Open the diff for the selected entry" } },
						{ "n", "o",              actions.select_entry,               { desc = "Open the diff for the selected entry" } },
						{ "n", "l",              actions.select_entry,               { desc = "Open the diff for the selected entry" } },
						{ "n", "<2-LeftMouse>",  actions.select_entry,               { desc = "Open the diff for the selected entry" } },
						{ "n", "<c-b>",          actions.scroll_view(-0.25),         { desc = "Scroll the view up" } },
						{ "n", "<c-f>",          actions.scroll_view(0.25),          { desc = "Scroll the view down" } },
						{ "n", "<tab>",          actions.select_next_entry,          { desc = "Open the diff for the next file" } },
						{ "n", "<s-tab>",        actions.select_prev_entry,          { desc = "Open the diff for the previous file" } },
						{ "n", "gf",             actions.goto_file_edit,             { desc = "Open the file in the previous tabpage" } },
						{ "n", "<C-w><C-f>",     actions.goto_file_split,            { desc = "Open the file in a new split" } },
						{ "n", "<C-w>gf",        actions.goto_file_tab,              { desc = "Open the file in a new tabpage" } },
						{ "n", "<localleader>e", actions.focus_files,                { desc = "Bring focus to the file panel" } },
						{ "n", "<localleader>b", actions.toggle_files,               { desc = "Toggle the file panel" } },
						{ "n", "g<C-x>",         actions.cycle_layout,               { desc = "Cycle available layouts" } },
						{ "n", "g?",             actions.help("file_history_panel"), { desc = "Open the help panel" } },
					},
					option_panel = {
						{ "n", "<tab>", actions.select_entry,         { desc = "Change the current option" } },
						{ "n", "q",     actions.close,                { desc = "Close the panel" } },
						{ "n", "g?",    actions.help("option_panel"), { desc = "Open the help panel" } },
					},
					help_panel = {
						{ "n", "q",     actions.close, { desc = "Close help menu" } },
						{ "n", "<esc>", actions.close, { desc = "Close help menu" } },
					},
				},
			}
		end
	}
}
