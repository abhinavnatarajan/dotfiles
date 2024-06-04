return {
	"barreiroleo/ltex_extra.nvim",
	dependencies = { "neovim/nvim-lspconfig" },
	version = "*",
	-- setup is called in the on_attach function of the ltex lsp server
	opts = {
		-- table <string> : languages for witch dictionaries will be loaded, e.g. { "es-AR", "en-US" }
		-- https://valentjn.github.io/ltex/supported-languages.html#natural-languages
		load_langs = { "en-GB" }, -- en-US as default
		-- boolean : whether to load dictionaries on startup
		init_check = true,
		-- string : relative or absolute path to store dictionaries
		-- e.g. subfolder in the project root or the current working directory: ".ltex"
		-- e.g. shared files for all projects:  vim.fn.expand("~") .. "/.local/share/ltex"
		path = ".ltex", -- project root or current working directory
		-- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
		log_level = "none",
		-- table : configurations of the ltex language server.
		-- Only if you are calling the server from ltex_extra
		server_opts = nil,
	},
}
