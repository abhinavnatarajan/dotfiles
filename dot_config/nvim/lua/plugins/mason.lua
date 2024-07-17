local icons = require("icons")
return
{
	{
		"williamboman/mason.nvim",
		version = "*",
		opts = {
			ui = {
				border = "rounded",
			},
		},
		keys = {
			{ "<leader>Lm", "<CMD>Mason<CR>", desc = require("icons").ui.Configure .. " Manage external tools", }
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			local ensure_installed = {}
			local install_lists = {
				require('config.LSP').ensure_installed,
				require('config.linters').ensure_installed,
				require('config.formatters').ensure_installed,
				require('config.DAP').ensure_installed
			}
			for _, val in ipairs(install_lists) do
				vim.list_extend(ensure_installed, val)
			end
			require('mason-tool-installer').setup {
				ensure_installed = ensure_installed,
			}
		end
	},
	{
		-- library of default configurations for various LSP servers
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
		-- bridge between mason and lspconfig
		-- automatic setup of servers installed by mason
		"williamboman/mason-lspconfig.nvim",
		version = "*",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		config = false -- manually call setup in lua/config/LSP/init.lua
	},
	{
		-- allow linters to act as LSP servers
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
}
