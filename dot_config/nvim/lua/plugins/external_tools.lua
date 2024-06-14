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
			handlers = {
				-- override the default handler
				-- pull our settings
				function(server_name)
					require("lspconfig")[server_name].setup(require("config.LSP.servers").get(server_name).config)
				end
			},
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
		opts = {
			ensure_installed = require("config.DAP.adapters").ensure_installed,
			handlers = {
					function (config)
						require("mason-nvim-dap").default_setup(config)
					end,
				python = require("config.DAP.adapters").get("python").handler
			}
		},
	}
}
