return {
	'stevearc/aerial.nvim',
	enabled = true,
	opts = {},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons"
	},
	config = function ()
		require("aerial").setup({
			backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
			layout = {
				max_width = 40,
				width = 40,
				min_width = {10, 0.1},
				-- Determines the default direction to open the aerial window. The 'prefer'
				-- options will open the window in the other direction *if* there is a
				-- different buffer in the way of the preferred direction
				-- Enum: prefer_right, prefer_left, right, left, float
				default_direction = "right",

				-- Determines where the aerial window will be opened
				--   edge   - open aerial at the far right/left of the editor
				--   window - open aerial to the right/left of the current window
				placement = "edge",

				-- When the symbols change, resize the aerial window (within min/max constraints) to fit
				resize_to_content = false,
			},
			-- Determines how the aerial window decides which buffer to display symbols for
			--   window - aerial window will display symbols for the buffer in the window from which it was opened
			--   global - aerial window will display symbols for the current window
			attach_mode = "global",

			-- Use symbol tree for folding. Set to true or false to enable/disable
			-- Set to "auto" to manage folds if your previous foldmethod was 'manual'
			-- This can be a filetype map (see :help aerial-filetype-map)
			manage_folds = true,

			-- When you fold code with za, zo, or zc, update the aerial tree as well.
			-- Only works when manage_folds = true
			link_folds_to_tree = true,

			-- Fold code when you open/collapse symbols in the tree.
			-- Only works when manage_folds = true
			link_tree_to_folds = true,

			ignore = {
				-- Ignore unlisted buffers. See :help buflisted
				unlisted_buffers =  true,

				-- Ignore diff windows (setting to false will allow aerial in diff windows)
				diff_windows = true,

				-- List of filetypes to ignore.
				-- filetypes = {},

				-- Ignored buftypes.
				-- Can be one of the following:
				-- false or nil - No buftypes are ignored.
				-- "special"    - All buffers other than normal, help and man page buffers are ignored.
				-- table        - A list of buftypes to ignore. See :help buftype for the
				--                possible values.
				-- function     - A function that returns true if the buffer should be
				--                ignored or false if it should not be ignored.
				--                Takes two arguments, `bufnr` and `buftype`.
				buftypes = "special",

				-- Ignored wintypes.
				-- Can be one of the following:
				-- false or nil - No wintypes are ignored.
				-- "special"    - All windows other than normal windows are ignored.
				-- table        - A list of wintypes to ignore. See :help win_gettype() for the
				--                possible values.
				-- function     - A function that returns true if the window should be
				--                ignored or false if it should not be ignored.
				--                Takes two arguments, `winid` and `wintype`.
				wintypes = "special",
			},
			-- Jump to symbol in source window when the cursor moves
			autojump = false,
			-- A list of all symbols to display. Set to false to display all symbols.
			-- This can be a filetype map (see :help aerial-filetype-map)
			-- To see all available values, see :help SymbolKind
			filter_kind = false,
			-- filter_kind = {
			-- 	"Class",
			-- 	"Constructor",
			-- 	"Enum",
			-- 	"Function",
			-- 	"Interface",
			-- 	"Module",
			-- 	"Method",
			-- 	"Struct",
			-- },
		})
	end
}
