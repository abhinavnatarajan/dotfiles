return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
		-- "mfussenegger/nvim-dap-python"
	},
	opts = {
		auto_refresh = false,
		search_workspace = true,
		search_venv_managers = true,
		name = {"venv", ".venv"},
		notify_user_on_activate = true,
		poetry_path = "~/.cache/pypoetry/virtualenvs/",
		pyenv_path = "~/.pyenv/versions/",
		anaconda_base_path = "~/mambaforge",
		anaconda_envs_path = "~/mambaforge/envs/"
  },
	cmd = { "VenvSelect", "VenvSelectCached", "VenvSelectCurrent" }
}
