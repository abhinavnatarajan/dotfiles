return {
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
}
