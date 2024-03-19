return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"jmbuhr/otter.nvim",
		"micangl/cmp-vimtex",
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = "make install_jsregexp",
			dependencies = {
				"rafamadriz/friendly-snippets",
				"molleweide/LuaSnip-snippets.nvim"
			},
			config = function() require("luasnip.loaders.from_vscode").lazy_load() end
		},
		"saadparwaiz1/cmp_luasnip",
		"petertriho/cmp-git",
	},
	lazy = true,
}
