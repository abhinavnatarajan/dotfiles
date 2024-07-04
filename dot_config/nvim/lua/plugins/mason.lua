local icons = require("icons")
return
{
	{
		"neovim/nvim-lspconfig",
		version = "*",
		cmd = {
			"LspStart",
			"LspStop",
			"LspRestart",
			"LspInfo",
			"LspLog",
		},
		keys = {
			{ "<leader>Li", "<CMD>LspInfo<CR>",    desc = icons.diagnostics.Information .. " LSP clients info" },
			{ "<leader>Lr", "<CMD>LspRestart<CR>", desc = icons.ui.Reload .. " Restart clients attached to this buffer" },
			{ "<leader>Lx", "<CMD>LspStop<CR>",    desc = icons.ui.BoldClose .. " Kill clients attached to this buffer" },
			{ "<leader>Ls", "<CMD>LspStart<CR>",   desc = icons.ui.Play .. " Start clients for this buffer" },
		},
		config = false,
	},
	{
		'nvimtools/none-ls.nvim',
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					-- these sources are not from Mason
					null_ls.builtins.hover.dictionary, -- get dictionary meaning of word on hover
					null_ls.builtins.hover.printenv, -- get current value of environment variable on hover
				},
			})
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		cmd = {
			"NullLsInstall",
			"NullLsUninstall",
			"NoneLsInstall",
			"NoneLsUninstall",
		},
		opts = {
			ensure_installed = require("config.LSP.linters").ensure_installed,
			handlers = require("config.LSP.linters").handlers,
		},
	},
	{
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
	},
	{
		-- automatic LSP installation and configuration using Mason
		"williamboman/mason-lspconfig.nvim",
		version = "*",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		cmd = { "LspInstall", "LspUninstall" },
		opts = {
			ensure_installed = require("config.LSP.servers").ensure_installed,
			handlers = require("config.LSP.servers").handlers,
		},
	},
	{
		-- automatic DAP installation and configuration using Mason
		'jay-babu/mason-nvim-dap.nvim',
		version = "*",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		cmd = {
			"DapInstall",
			"DapUninstall",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = require("config.DAP.adapters").ensure_installed,
				handlers = require("config.DAP.adapters").handlers,
			})
		end
	},
}
