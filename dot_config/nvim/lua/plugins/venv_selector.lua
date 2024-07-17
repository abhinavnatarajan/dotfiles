return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
	},
	branch = "regexp",
	cmd = { "VenvSelect", "VenvSelectLog" },
	event = { "LspAttach *.py", "LspAttach pyproject.toml" },
	config = function(_, opts)
		require("venv-selector").setup(opts)
		require("autocmds").define_autocmd(
			"LspAttach",
			{
				desc = "Shortcut key to change python virtual environment for LSP",
				group = "venv_select",
				callback = function(args)
					if vim.tbl_contains({
						"pyright",
						"basedpyright",
						"pylance",
						"pylsp",
					}, vim.lsp.get_client_by_id(args.data.client_id).name) then
						local DefaultOpts = require("config.keybinds").DefaultOpts
						vim.keymap.set("n", "<leader>Lef", "<CMD>VenvSelect<CR>",
							DefaultOpts { desc = require("icons").ui.Search .. " Find environment", buffer = 0 })
						vim.keymap.set("n", "<leader>Lei",
							function()
								local venv = require("venv-selector").venv()
								if venv then
									vim.notify("Current environment: " .. venv)
								else
									vim.notify("No virtual environment active")
								end
							end,
							DefaultOpts { desc = require("icons").ui.ChevronRightBoxOutline .. " Current environment info", buffer = 0 })
						vim.keymap.set(
							"n",
							"<leader>Lex",
							function()
								require("venv-selector").deactivate()
							end,
							DefaultOpts {
									desc = require("icons").ui.Close .. " Deactivate virtual environment",
									buffer = 0,
								}
						)

						-- if which-key is loaded then add a prefix description for venv-selector
						local have_which_key = false
						for _, plugin in ipairs(require("lazy").plugins()) do
							if plugin.name == "which-key.nvim" then
								have_which_key = true
							end
						end
						if have_which_key then
							require("which-key").register({
								["<leader>Le"] = {
									require("nvim-web-devicons").get_icon_by_filetype("python")
									.. " Manage python virtual envs"
								}
							})
						end
					end
				end,
			})
	end,
	opts = {
		settings = {
			cache = {
				file = "~/.cache/venv-selector/venvs2.json",
			},
			search = {
				hatch = {
					command = "$FD 'bin/python$' ~/.local/share/hatch/env/virtual --full-path --color never -E '*-build*' -E /proc"
				},
				mambaforge_envs = {
					command = "$FD '/bin/python$' ~/mambaforge/envs --full-path --color never -E /proc -a -L",
					type = "anaconda"
				},
			},
			options = {
				on_venv_activate_callback = nil,     -- callback function for after a venv activates
				enable_default_searches = true,      -- switches all default searches on/off
				enable_cached_venvs = true,          -- use cached venvs that are activated automatically when a python file is registered with the LSP.
				cached_venv_automatic_activation = true, -- if set to false, the VenvSelectCached command becomes available to manually activate them.
				activate_venv_in_terminal = true,    -- activate the selected python interpreter in terminal windows opened from neovim
				set_environment_variables = true,    -- sets VIRTUAL_ENV or CONDA_PREFIX environment variables
				notify_user_on_venv_activation = false, -- notifies user on activation of the virtual env
				search_timeout = 5,                  -- if a search takes longer than this many seconds, stop it and alert the user
				debug = false,                       -- enables you to run the VenvSelectLog command to view debug logs
				-- fd_binary_name = M.find_fd_command_name(),   -- plugin looks for `fd` or `fdfind` but you can set something else here

				-- telescope viewer options
				on_telescope_result_callback = nil, -- callback function for modifying telescope results
				show_telescope_search_type = true, -- Shows which of the searches found which venv in telescope
				telescope_filter_type =
				"substring"                     -- When you type something in telescope, filter by "substring" or "character"
			},
		},
	},
}
