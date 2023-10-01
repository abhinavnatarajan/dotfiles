return {
	"goerz/jupytext.vim",
	-- event = "BufReadCmd *.ipynb",
	init = function()
		vim.g.jupytext_fmt = 'py'
	end
}
