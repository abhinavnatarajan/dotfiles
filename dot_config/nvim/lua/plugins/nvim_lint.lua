return {
	'mfussenegger/nvim-lint',
	-- this plugin is not versioned
	config = function()
		-- TODO: keymappings to enable/disable linters
		local lint = require("lint")
		lint.linters_by_ft = {}
		local linters_all_ft = {
			"codespell",
			"vale",
			"editorconfig-checker",
		}
		for _, linter in ipairs(linters_all_ft) do
			lint.linters[linter] = require("lint.util").wrap(lint.linters[linter], function(diagnostic)
				diagnostic.severity = vim.diagnostic.severity.HINT
				return diagnostic
			end)
		end
		require("autocmds").define_autocmd(
			{ "InsertLeave", "BufWritePost" },
			{
				group = "nvim_lint_trigger",
				desc = "Trigger linting on text change",
				callback = function()
					require("lint").try_lint()
					if vim.bo.buflisted then
						for _, linter in ipairs(linters_all_ft) do
							lint.try_lint(linter)
						end
					end
				end
			})
		vim.keymap.set(
			"n",
			"<leader>Ll",
			function()
				local linters = lint.linters_by_ft[vim.bo.filetype]
				local msg = linters and vim.inspect(linters) or "No linters configured for current file."
				vim.notify(msg)
			end,
			require("config.keybinds").DefaultOpts { desc = "Linter info" }
		)
	end,
}
