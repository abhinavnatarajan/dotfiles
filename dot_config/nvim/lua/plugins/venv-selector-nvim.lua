return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
		-- "mfussenegger/nvim-dap-python"
	},
	cmd = { "VenvSelect", "VenvSelectCached", "VenvSelectCurrent" },
	init = function()
		require("autocmds").define_autocmds({
			{
				"LspAttach",
				{
					desc = "Shortcut key to change python virtual environment for LSP",
					group = "venv_select",
					callback = function(args)
						if vim.lsp.get_client_by_id(args.data.client_id).name == "pyright" then
							require("nvim-web-devicons")
							local wk = require("which-key")
							wk.register(
								{
									["<leader>Lv"] = {
										name = require("nvim-web-devicons").get_icon_by_filetype("python")
												.. " Manage python virtual envs",
										["f"] = { "<CMD>VenvSelect<CR>", require("icons").ui.Search .. " Find environment" },
										["i"] = {
											"<CMD>VenvSelectCurrent<CR>",
											require("icons").ui.ChevronRightBoxOutline .. " Current environment info",
										},
										["r"] = {
											"<CMD>VenvSelectCached<CR>",
											require("icons").ui.History .. " Initialise last used environment",
										},
									},
								},
								{
									buffer = 0,
									noremap = true,
									silent = true,
								})
						end
					end,
				}
			},
		})
	end,
	opts = {
		auto_refresh = true,
		search = false, -- whether to search parent directories
		parents = 2,
		search_workspace = true,
		search_venv_managers = true,
		name = { "venv", ".venv", ".hatch" },
		notify_user_on_activate = true,
		poetry_path = "~/.cache/pypoetry/virtualenvs/",
		pyenv_path = "~/.pyenv/versions/",
		hatch_path = "~/.local/share/hatch/env/virtual/",
		anaconda_base_path = "~/mambaforge",
		anaconda_envs_path = "~/mambaforge/envs/"
	},
}
