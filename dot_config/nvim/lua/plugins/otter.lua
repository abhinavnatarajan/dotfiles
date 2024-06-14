return {
	"jmbuhr/otter.nvim",
	dependencies = {
		'neovim/nvim-lspconfig',
		'nvim-treesitter/nvim-treesitter'
	},
	init = function()
		require("autocmds").define_autocmd(
			"FileType",
			{
				desc = "Enable otter on markup files where injections are allowed",
				group = "activate_otter",
				pattern = { "markdown", "quarto", "rmd" },
				callback = function()
					-- Otter config
					-- table of embedded languages to look for.
					-- default = nil, which will activate
					-- any embedded languages found
					local languages = nil
					-- enable completion/diagnostics
					-- defaults are true
					local completion = true
					local diagnostics = true
					-- treesitter query to look for embedded languages
					-- uses injections if nil or not set
					local tsquery = nil

					require("otter").activate(languages, completion, diagnostics, tsquery)
				end,
			}
		)
	end,
}
