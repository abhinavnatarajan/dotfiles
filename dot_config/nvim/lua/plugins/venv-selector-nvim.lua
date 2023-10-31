return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
		-- "mfussenegger/nvim-dap-python"
	},
	opts = {
		auto_refresh = true,
		search = false, -- whether to search parent directories
		parents = 2,
		search_workspace = true,
		search_venv_managers = true,
		name = {"venv", ".venv", ".hatch"},
		notify_user_on_activate = true,
		poetry_path = "~/.cache/pypoetry/virtualenvs/",
		pyenv_path = "~/.pyenv/versions/",
		hatch_path = "~/.local/share/hatch/env/virtual/",
		anaconda_base_path = "~/mambaforge",
		anaconda_envs_path = "~/mambaforge/envs/"
  },
	cmd = { "VenvSelect", "VenvSelectCached", "VenvSelectCurrent" }
}
