-- Labelled vimtex keybinds
local vimtex_keybind = function()
	local DefaultOpts = require("utils").prototype({
		buffer = 0,   -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
		expr = false,
	})
	local mappings = {
		{ "n", "<localleader>i", "<CMD>VimtexInfo<CR>",          DefaultOpts { desc = "Info" }, },
		{ "n", "<localleader>t", "<CMD>VimtexTocToggle<CR>",     DefaultOpts { desc = "Toggle table of contents" }, },
		{ "n", "<localleader>q", "<CMD>VimtexLog<CR>",           DefaultOpts { desc = "Vimtex logs" }, },
		{ "n", "<localleader>v", "<CMD>VimtexView<CR>",          DefaultOpts { desc = "Forward search" }, },
		{ "n", "<localleader>l", "<CMD>VimtexCompile<CR>",       DefaultOpts { desc = "Compile" }, },
		{ "n", "<localleader>k", "<CMD>VimtexStop<CR>",          DefaultOpts { desc = "Stop compilation" }, },
		{ "n", "<localleader>o", "<CMD>VimtexCompileOutput<CR>", DefaultOpts { desc = "View compiler output" }, },
		{ "n", "<localleader>g", "<CMD>VimtexStatus<CR>",        DefaultOpts { desc = "Compiler status" }, },
		{ "n", "<localleader>c", "<CMD>VimtexClean<CR>",         DefaultOpts { desc = "Clean build files" }, },
		{ "n", "<localleader>C", "<CMD>VimtexClean!<CR>",        DefaultOpts { desc = "Clean build and output files" }, },
		{ "n", "<localleader>m", "<CMD>VimtexImapsList<CR>",     DefaultOpts { desc = "List insert mode keymaps" }, },
		{ "n", "<localleader>s", "<CMD>VimtexToggleMain<CR>",    DefaultOpts { desc = "Toggle main file" }, },
		{ "n", "<localleader>a", "<CMD>VimtexContextMenu<CR>",   DefaultOpts { desc = "Context menu" }, },
		{ "n", "<localleader>h", "<CMD>VimtexDocPackage<CR>",   DefaultOpts { desc = "Documentation for command" }, },
	}
	for _, mapping in ipairs(mappings) do
		vim.keymap.set(unpack(mapping))
	end
end

return
{
	{
		"lervag/vimtex",
		version = "*",
		lazy = false, -- need this for synctex to work correctly
		init = function()
			-- Use init for configuration, don't use the more common "config".
			vim.g.vimtex_fold_enabled = 0 -- use treesitter for this
			vim.g.vimtex_indent_enabled = 0
			vim.g.vimtex_indent_bib_enabled = 0
			vim.g.vimtex_quickfix_open_on_warning = 0
			vim.g.vimtex_quickfix_mode = 2
			vim.g.vimtex_mappings_enabled = 1
			vim.g.vimtex_mappings_prefix = "<leader>l"
			vim.g.vimtex_imaps_enabled = 1
			vim.g.vimtex_text_obj_enabled = 1
			vim.g.vimtex_motion_enabled = 1
			vim.g.syntax_enabled = 1
			vim.g.vimtex_syntax_conceal_disable = 1
			vim.g.vimtex_view_method = 'sioyek'
			vim.g.vimtex_complete_enabled = 0
			vim.g.vimtex_compiler_latexmk = {
				aux_dir = '.build',
				out_dir = '',
				callback = 1,
				continuous = 1,
				executable = 'latexmk',
				hooks = {},
				options = {
					'-verbose',
					'-file-line-error',
					'-synctex=1',
					'-interaction=nonstopmode',
				},
			}
			require("autocmds").define_autocmd(
				"Filetype",
				{
					pattern = "tex",
					group = "vimtex_keybind",
					desc = "Set up vimtex keybinds",
					callback = vimtex_keybind,
				}
			)
		end
	},
}
