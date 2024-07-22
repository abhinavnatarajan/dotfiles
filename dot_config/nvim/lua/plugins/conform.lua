return {
	"stevearc/conform.nvim",
	version = "*",
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>F",
			function()
				require("conform").format({
					lsp_format = "fallback", -- if set to true, then only falls back when there are no formatters
					timeout_ms = 2000,
				}, function(_, did_edit) -- callback
					if did_edit then
						vim.cmd("silent GuessIndent")
					end
				end)
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
			"<leader>Lf",
			"<CMD>silent ConformInfo<CR>",
			desc = "Formatter info for buffer",
		},
	},
	-- Everything in opts will be passed to setup()
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			bib = { "bibtex-tidy" },
			python = { "ruff_organize_imports", "ruff_format" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			-- lua = { "stylua" },
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
