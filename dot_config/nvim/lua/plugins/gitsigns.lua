local icons = require("icons")
return {
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
			virt_text_pos = "right_aligned", -- 'eol' | 'overlay' | 'right_align'
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
		trouble = true, -- use trouble.nvim for qflist
		diff_opts = {
			algorithm = "histogram",
			internal = false,
		},
		base = nil, -- diff against index by default
		on_attach = function()
			-- vim.keymap.set(
			-- 	"n", "<leader>gs",
			-- 	function()
			-- 		require("gitsigns").stage_hunk()
			-- 	end,
			-- 	{ desc = "Stage hunk" }
			-- )
			-- vim.keymap.set(
			-- 	"n", "<leader>gr",
			-- 	function()
			-- 		require("gitsigns").reset_hunk()
			-- 	end,
			-- 	{ desc = "Reset hunk" }
			-- )
			-- vim.keymap.set(
			-- 	"n", "<leader>gu",
			-- 	function()
			-- 		require("gitsigns").undo_stage_hunk()
			-- 	end,
			-- 	{ desc = "Undo stage hunk" }
			-- )
			vim.keymap.set(
				"n", "<leader>gK",
				function()
					require("gitsigns").preview_hunk()
				end,
				{ desc = "Hunk preview (hover)" }
			)
			vim.keymap.set(
				"n", "<leader>gp",
				function()
					require("gitsigns").preview_hunk_inline()
				end,
				{ desc = "Hunk preview (inline)" }
			)
			-- vim.keymap.set(
			-- 	"n", "<leader>gS",
			-- 	function()
			-- 		require("gitsigns").stage_buffer()
			-- 	end,
			-- 	{ desc = "Stage buffer" }
			-- )
			-- vim.keymap.set(
			-- 	"n", "<leader>gR",
			-- 	function()
			-- 		require("gitsigns").reset_buffer()
			-- 	end,
			-- 	{ desc = "Reset buffer" }
			-- )
			-- vim.keymap.set(
			-- 	"n", "<leader>gD",
			-- 	function()
			-- 		require("gitsigns").diffthis("index", { split = "rightbelow" })
			-- 	end,
			-- 	{ desc = icons.git.Diff .. " Diff against index" }
			-- )
			-- vim.keymap.set(
			-- 	"n", "<leader>gd",
			-- 	function()
			-- 		require("gitsigns").diffthis("@", { split = "rightbelow" })
			-- 	end,
			-- 	{ desc = icons.git.Diff .. " Diff against HEAD" }
			-- )
			vim.keymap.set(
				"n", "<leader>gt",
				function()
					require("gitsigns").toggle_deleted()
				end,
				{ desc = "Toggle deleted" }
			)
			-- vim.keymap.set("n", "]c", function() require("gitsigns").next_hunk() end, { desc = "Next hunk" })
			-- vim.keymap.set("n", "[c", function() require("gitsigns").prev_hunk() end, { desc = "Previous hunk" })
		end
	},
}
