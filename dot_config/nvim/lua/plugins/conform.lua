return {
	"stevearc/conform.nvim",
	version = "*",
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>Lf",
			function()
				require("conform").format(
					{
						lsp_fallback = false, -- if set to true, then only falls back when there are no formatters
						quiet = true,
						timeout_ms = 2000,
					},
					-- callback
					function(err, did_edit)
						if err or not did_edit then
							vim.lsp.buf.format({ timeout_ms = 2000 })
						end
					end)
				vim.cmd("silent GuessIndent")
			end,
			desc = require("icons").ui.Indent .. " Format buffer",
			mode = { "n", "x" },
		},
		{
			"<leader>$",
			function()
				require("conform").format({
					formatters = { "trim_whitespace" },
					quiet = true,
				})
			end,
			desc = require("icons").ui.WhiteSpace .. " Trim whitespace",
			mode = { "n", "x" },
		},
		{
			"<leader>LF",
			function()
				local conform = require("conform")
				local formatter_list = conform.list_formatters()
				if vim.tbl_isempty(formatter_list) then
					vim.notify('No formatters found, will use LSP.', vim.log.levels.INFO)
				else
					vim.notify('Formatters found: ' .. table.concat(formatter_list, ', '), vim.log.levels.INFO)
				end
			end
		}
	},
	-- Everything in opts will be passed to setup()
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			bib = { "bibtex-tidy" },
			python = { "ruff_organize_imports", "ruff_format" }
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end
}
