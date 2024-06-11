local icons = require("icons")

---grep a string in the current buffer
local buffer_grep = function()
	require("telescope.builtin").live_grep({
		search_dirs = { vim.fn.expand("%:p") },
		path_display = "hidden",
		prompt_title = "Grep string (buffer)",
		additional_args = { "--smart-case" },
	})
end

---fzf a string in the current buffer
local buffer_fzf = function()
	require("telescope.builtin").current_buffer_fuzzy_find({
		prompt_title = "Fzf string (buffer)",
	})
end

---grep a string in the current working directory
local cwd_grep = function()
	require("telescope.builtin").live_grep({
		prompt_title = "Grep string (cwd)",
		additional_args = { "--smart-case" },
	})
end

---fzf a string in the current working directory
local cwd_fzf = function()
	require("telescope.builtin").grep_string({
		shorten_path = true,
		word_match = "-w",
		only_sort_text = true,
		search = "",
		prompt_title = "Fzf string (cwd)",
	})
end

---mapping to delete a buffer from the telescope buffer picker
local buffer_delete = function(prompt_bufnr)
	local action_state = require("telescope.actions.state")
	local bufdelete = require("bufdelete").bufdelete
	local current_picker = action_state.get_current_picker(prompt_bufnr)
	current_picker:delete_selection(
		function(selection) bufdelete(selection.bufnr, true) end
	)
end

---use telescope to create a save as dialog
local save_as = function(opts)
	local fb_picker = require("telescope").extensions.file_browser
	local fb_utils = require("telescope._extensions.file_browser.utils")
	local action_state = require("telescope.actions.state")
	local actions = require("telescope.actions")
	local state = require("telescope.state")
	local Path = require "plenary.path"
	local bufdelete = require("bufdelete").bufdelete
	-- return Path file on success, otherwise nil
	local create = function(file, finder)
		if not file then
			return
		end
		local os_sep = Path.path.sep
		if
				file == ""
				or (finder.files and file == finder.path .. os_sep)
				or (not finder.files and file == finder.cwd .. os_sep)
		then
			if not finder.quiet then
				vim.notify("Please enter a valid file or folder name!", vim.log.levels.WARN)
			end
			return
		end
		file = Path:new(file)
		if not file:is_dir() then
			file:touch { parents = true }
		else
			Path:new(file.filename:sub(1, -2)):mkdir { parents = true }
		end
		return file
	end
	fb_picker.file_browser {
		prompt_title = "Save as",
		attach_mappings = function()
			local saveas = function(prompt_bufnr)
				local entry = action_state.get_selected_entry()
				local current_picker = action_state.get_current_picker(prompt_bufnr)
				local finder = current_picker.finder
				if entry == nil then
					-- vim.notify("No file selected!", "ERROR")
					local os_sep = Path.path.sep
					local input = (finder.files and finder.path or finder.cwd) .. os_sep .. current_picker:_get_prompt()
					local file = create(input, finder)
					if file then
						-- pretend new file path is entry
						local path = file:absolute()
						state.set_global_key("selected_entry", { path, value = path, path = path, Path = file })
						entry = action_state.get_selected_entry()
					end
				end
				if type(entry) == "table" then
					local entry_path = entry.Path
					if entry_path:is_dir() then
						finder.path = entry_path:absolute()
						fb_utils.redraw_border_title(current_picker)
						current_picker:refresh(
							finder,
							{ new_prefix = fb_utils.relative_path_prefix(finder), reset_prompt = true, multi = current_picker._multi }
						)
					else
						actions.close(prompt_bufnr)
						opts = opts or {}
						local close_current = opts.close_current or false
						if close_current then
							vim.cmd("w! " .. entry_path:absolute())
							bufdelete(vim.fn.bufnr("#"), true)
						else
							vim.cmd("saveas! " .. entry_path:absolute())
						end
					end
				end
			end
			actions.select_default:replace(saveas)
			return true
		end
	}
end

---save the current buffer, if it is a new file, open the save as dialog
local check_save_as = function()
	if vim.api.nvim_buf_get_name(0) == "" then
		save_as {
			close_current = true,
		}
	else
		vim.cmd [[silent w!]]
	end
end

---browse nvim config directory with telescope
local browse_config_files = function(opts)
	require("telescope").extensions.file_browser.file_browser(vim.tbl_extend("force", opts or {},
		{ path = (string.gsub(vim.env.MYVIMRC, "/init.lua$", "")), prompt_title = "Browse config files" }))
end

return {
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
			"BurntSushi/ripgrep",
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build =
				'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
			},
		},
		cmd = 'Telescope',
		keys = {
			{
				"<leader>fg",
				buffer_grep,
				desc = icons.ui.FindText .. " Grep string (buffer)",
			},
			{
				"<leader>fs",
				buffer_fzf,
				desc = icons.ui.FindText .. " Fzf string (buffer)",
			},
			{
				"<leader>fG",
				cwd_grep,
				desc = icons.ui.FindText .. " Grep string (cwd)",
			},
			{
				"<leader>fS",
				cwd_fzf,
				desc = icons.ui.FindText .. " Fzf string (cwd)",
			},
			{
				"<leader>ff",
				function()
					local ok = pcall(require("telescope.builtin").git_files)
					if not ok then
						require("telescope.builtin").find_files()
					end
				end,
				desc = icons.ui.FindFile .. " Fzf files",

			},
			{
				"<leader>fr",
				function() require("telescope.builtin").oldfiles() end,
				desc = icons.ui.History .. " Recent files",
			},
			{
				"<leader>ft",
				function() require("telescope.builtin").filetypes() end,
				desc = icons.syntax.Text .. " Set filetype",
			},

			{
				"<leader>h",
				function() require("telescope.builtin").help_tags() end,
				desc = icons.ui.FindFile .. " Search in help topics",
			},
			{
				"<leader>bf",
				function() require("telescope.builtin").buffers() end,
				desc = icons.ui.FindFile .. " Find buffer",
			},
			{
				"<leader>T",
				function() require("telescope.builtin").builtin({ include_extensions = true }) end,
				desc = icons.ui.Telescope .. " Telescope",
			}
		},
		config = function()
			local telescope = require('telescope')
			telescope.setup {
				defaults = {
					layout_strategy = "horizontal",
					layout_config = {
						mirror = false,
					},
					wrap_results = true,
					winblend = (vim.g.neovide and 25) or 5,
					get_selection_window = require("utils.windows").get_window,
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						-- "--smart-case" -- we enable this in the keybinds, but we don't want it in the command line
					}
				},
				pickers = {
					help_tags = {
						mappings = {
							i = {
								["<CR>"] = "select_vertical"
							},
							n = {
								["<CR>"] = "select_vertical"
							},
						}
					},
					find_files = {
						no_ignore = true,
					},
					git_files = {
						no_ignore = true,
					},
					oldfiles = {
						prompt_title = "Recent files"
					},
					buffers = {
						mappings = {
							n = {
								d = buffer_delete,
							},
							i = {
								["<C-x>"] = buffer_delete,
							}
						}
					}
				},
				fzf = {
					fuzzy = true,              -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case",  -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
				notify = {
					timeout = 2500,
					render = 'default'
				},
			}
			require("autocmds").define_autocmd(
			-- enable wrapping on Telescope previewers
				"User",
				{
					group = "wrap_telescope_previews",
					pattern = "TelescopePreviewerLoaded",
					callback = function()
						vim.wo.wrap = true
						vim.wo.conceallevel = 0
					end
				})
			telescope.load_extension("fzf")
		end,
	},
	{
		"debugloop/telescope-undo.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		keys = {
			{
				"<leader>u",
				function() require("telescope").extensions.undo.undo() end,
				desc = require("icons").ui.Undo .. " Undo history"
			}
		},
		cmd = { "Telescope undo" },
		config = function(_, opts)
			-- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
			-- configs for us. We won't use data, as everything is in it's own namespace (telescope
			-- defaults, as well as each extension).
			require("telescope").setup(opts)
			require("telescope").load_extension("undo")
		end,
	},
	{
		'nvim-telescope/telescope-file-browser.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		cmd = { "Telescope file_brower" },
		keys = {
			{
				"<leader>w",
				check_save_as,
				desc = icons.ui.Save .. " Save",
			},
			{
				"<leader>fw",
				save_as,
				desc = icons.ui.SaveAs .. " Save as",
			},
			{
				"<leader>fd",
				function() require("telescope").extensions.file_browser.file_browser() end,
				desc = icons.ui.FolderOpen .. " Browse files",
			},
			{
				"<leader>sf",
				browse_config_files,
				desc = icons.ui.FolderOpen .. " Browse config files",
			}
		},
		opts = {
			extensions = {
				file_browser = {
					hijack_netrw = true,
					use_fd = true,
					respect_gitignore = false,
					hidden = {
						file_browser = true,
						folder_browser = true,
					},
					collapse_dirs = false,
					git_status = true,
					prompt_path = true
				},
			}
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("file_browser")
		end
	},
	{
		"tsakirist/telescope-lazy.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		cmd = { "Telescope lazy" },
		keys = {
			{
				"<leader>Pf",
				function() require("telescope").extensions.lazy.lazy() end,
				desc = icons.ui.FolderOpen .. " Explore plugin files"
			}
		},
		opts = {
			extensions = {
				lazy = {
					-- Optional theme (the extension doesn't set a default theme)
					theme = "ivy",
					-- Whether or not to show the icon in the first column
					show_icon = true,
					-- Mappings for the actions
					mappings = {
						open_in_browser = "<C-o>",
						open_in_file_browser = "<C-e>",
						open_in_find_files = "<C-f>",
						open_in_live_grep = "<C-g>",
						open_in_terminal = "<C-t>",
						open_plugins_picker = "<C-b>", -- Works only after having called first another action
						open_lazy_root_find_files = "<C-r>f",
						open_lazy_root_live_grep = "<C-r>g",
						change_cwd_to_plugin = "<C-c>d",
					},
					-- Extra configuration options for the actions
					actions_opts = {
						open_in_browser = {
							-- Close the telescope window after the action is executed
							auto_close = false,
						},
						change_cwd_to_plugin = {
							-- Close the telescope window after the action is executed
							auto_close = false,
						},
					},
					-- Configuration that will be passed to the window that hosts the terminal
					-- For more configuration options check 'nvim_open_win()'
					terminal_opts = {
						relative = "editor",
						style = "minimal",
						border = "rounded",
						title = "Telescope lazy",
						title_pos = "center",
						width = 0.5,
						height = 0.5,
					},
				},
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("lazy")
		end
	}
}
