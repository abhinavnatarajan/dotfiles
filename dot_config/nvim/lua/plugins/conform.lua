return {
	"stevearc/conform.nvim",
	version = "*",
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>+",
			function()
				require("conform").format({
					lsp_fallback = false, -- if set to true, then only falls back when there are no formatters
					quiet = true,
				}, function(err, did_edit)
					if err or not did_edit then
						vim.lsp.buf.format()
					end
				end)
			end,
			desc = require("icons").ui.Indent .. "Format buffer",
			mode = { "n", "x" },
		},
	},
	-- Everything in opts will be passed to setup()
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			bib = { "bibtex-tidy" },
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
