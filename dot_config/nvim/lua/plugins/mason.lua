return {
	"williamboman/mason.nvim",
	version = "*",
	opts = {
		ui = {
			border = "rounded",
		},
	},
	keys = {
		{ "<leader>Lm", "<CMD>Mason<CR>", desc = require("icons").ui.Configure .. " Manage installed LSP servers", }
	},
	cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstallAll", "MasonLog" },
}
