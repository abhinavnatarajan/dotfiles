return {
	"lewis6991/gitsigns.nvim",
	event = "User FileOpened",
	cmd = "Gitsigns",
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
		numhl = false,   -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false,  -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
		watch_gitdir = {
			follow_files = true,
		},
		attach_to_untracked = true,
		current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 1000,
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
		yadm = {
			enable = false,
		},
		diff_opts = {
			algorithm = "patience",
			internal = false,
		},
	},
	init = function()
		--
		-- ["s"] = {
		-- 	function()
		-- 		require("gitsigns").stage_hunk()
		-- 	end,
		-- 	"Stage hunk",
		-- },
		-- ["r"] = {
		-- 	function()
		-- 		require("gitsigns").reset_hunk()
		-- 	end,
		-- 	"Reset hunk",
		-- },
		-- ["u"] = {
		-- 	function()
		-- 		require("gitsigns").undo_stage_hunk()
		-- 	end,
		-- 	"Undo stage hunk",
		-- },
		-- ["p"] = {
		-- 	function()
		-- 		require("gitsigns").preview_hunk()
		-- 	end,
		-- 	"Preview hunk",
		-- },
		-- ["S"] = {
		-- 	function()
		-- 		require("gitsigns").stage_buffer()
		-- 	end,
		-- 	"Stage buffer",
		-- },
		-- ["R"] = {
		-- 	function()
		-- 		require("gitsigns").reset_buffer()
		-- 	end,
		-- 	"Reset buffer",
		-- },
		-- ["d"] = {
		-- 	function()
		-- 		require("gitsigns").diffthis(nil, { split = "rightbelow" })
		-- 	end,
		-- 	"Diff this",
		-- },
		-- ["D"] = {
		-- 	function()
		-- 		require("gitsigns").diffthis("~")
		-- 	end,
		-- 	"Diff this",
		-- },
		-- ["t"] = {
		-- 	function()
		-- 		require("gitsigns").toggle_deleted()
		-- 	end,
		-- 	"Toggle deleted",
		-- },
	end,
}
