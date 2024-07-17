return {
	"Shatur/neovim-session-manager",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false,
	config = function()
		local Path = require("plenary.path")
		local config = require("session_manager.config")
		local icons = require("icons")
		vim.keymap.set("n", "<leader>kf", [[<CMD>SessionManager load_session<CR>]],
			{ desc = icons.ui.FindFolder .. " Load workspace", })
		vim.keymap.set("n", "<leader>kd", [[<CMD>SessionManager >]], { desc = icons.ui.Trash .. " Delete workspace", })
		vim.keymap.set("n", "<leader>kw", "<CMD>SessionManager save_current_session<CR>",
			{ desc = icons.ui.Save .. " Save current workspace", })
		vim.keymap.set("n", "<leader>kr", [[<CMD>SessionManager load_last_session<CR>]],
			{ desc = icons.ui.History .. " Load last session", })
		vim.list_extend(require('config.keybinds').which_key_defaults, { { "<Leader>k", group = icons.ui.Project .. " Workspaces" } })
		require("session_manager").setup({
			sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions"), -- The directory where the session files will be saved.
			-- session_filename_to_dir = session_filename_to_dir, -- Function that replaces symbols into separators and colons to transform filename into a session directory.
			-- dir_to_session_filename = dir_to_session_filename, -- Function that replaces separators and colons into special symbols to transform session directory into a filename. Should use `vim.loop.cwd()` if the passed `dir` is `nil`.
			autoload_mode = config.AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
			autosave_last_session = true,                -- Automatically save last session on exit and on session switch.
			autosave_ignore_not_normal = true,           -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
			autosave_ignore_dirs = {},                   -- A list of directories where the session will not be autosaved.
			autosave_ignore_filetypes = {                -- All buffers of these file types will be closed before the session is saved.
				"gitcommit",
				"gitrebase",
				"Trouble",
			},
			autosave_ignore_buftypes = {
				"terminal",
				"nofile",
			},                            -- All buffers of these buffer types will be closed before the session is saved.
			autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
			max_path_length = 120,        -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
		})
		require("autocmds").define_autocmd(
			"User",
			{
				group = "save_session_notify",
				pattern = "SessionSavePost",
				callback = function() vim.notify("Saved session for workspace\n" .. vim.fn.getcwd()) end
			})
	end,
}
