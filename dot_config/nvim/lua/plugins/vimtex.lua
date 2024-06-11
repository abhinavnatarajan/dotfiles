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
		{ { "n", "x" }, "<leader>\\L", "<plug>(vimtex-compile-selected)", DefaultOpts { desc = "Compile selected" }, },
		{ "n",          "<leader>\\i", "<plug>(vimtex-info-full)",        DefaultOpts { desc = "Info" }, },
		{ "n",          "<leader>\\I", "<plug>(vimtex-info-full)",        DefaultOpts { desc = "Info (full)" }, },
		{ "n",          "<leader>\\t", "<plug>(vimtex-toc-toggle)",       DefaultOpts { desc = "Toggle table of contents" }, },
		{ "n",          "<leader>\\q", "<plug>(vimtex-log)",              DefaultOpts { desc = "Log" }, },
		{ "n",          "<leader>\\v", "<plug>(vimtex-view)",             DefaultOpts { desc = "View document" }, },
		{ "n",          "<leader>\\r", "<plug>(vimtex-reverse-search)",   DefaultOpts { desc = "Reverse search" }, },
		{ "n",          "<leader>\\l", "<plug>(vimtex-compile)",          DefaultOpts { desc = "Compile" }, },
		{ "n",          "<leader>\\k", "<plug>(vimtex-stop)",             DefaultOpts { desc = "Stop" }, },
		{ "n",          "<leader>\\K", "<plug>(vimtex-stop-all)",         DefaultOpts { desc = "Stop (all)" }, },
		{ "n",          "<leader>\\e", "<plug>(vimtex-errors)",           DefaultOpts { desc = "Errors" }, },
		{ "n",          "<leader>\\o", "<plug>(vimtex-compile-output)",   DefaultOpts { desc = "Compiler output" }, },
		{ "n",          "<leader>\\g", "<plug>(vimtex-status)",           DefaultOpts { desc = "Status" }, },
		{ "n",          "<leader>\\G", "<plug>(vimtex-status-all)",       DefaultOpts { desc = "Status (all)" }, },
		{ "n",          "<leader>\\c", "<plug>(vimtex-clean)",            DefaultOpts { desc = "Clean" }, },
		{ "n",          "<leader>\\C", "<plug>(vimtex-clean-full)",       DefaultOpts { desc = "Clean (full)" }, },
		{ "n",          "<leader>\\m", "<plug>(vimtex-imaps-list)",       DefaultOpts { desc = "List insert mode keymaps" }, },
		{ "n",          "<leader>\\x", "<plug>(vimtex-reload)",           DefaultOpts { desc = "Reload Vimtex" }, },
		{ "n",          "<leader>\\X", "<plug>(vimtex-reload-state)",     DefaultOpts { desc = "Reload Vimtex state" }, },
		{ "n",          "<leader>\\s", "<plug>(vimtex-toggle-main)",      DefaultOpts { desc = "Toggle main file" }, },
		{ "n",          "<leader>\\a", "<plug>(vimtex-context-menu)",     DefaultOpts { desc = "Context menu" }, },
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
		ft = { "tex", "tikz", "bib" },
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
