return {
	"goerz/jupytext.vim",
	-- event = "BufReadCmd *.ipynb",
	init = function()
		vim.g.jupytext_fmt = 'py:percent'
		vim.g.jupytext_to_ipynb_opts = '--to=ipynb --update'
	end
}
