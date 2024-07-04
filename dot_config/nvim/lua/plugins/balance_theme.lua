return {
	'MetriC-DT/balance-theme.nvim',
	lazy = false,
	config = function()
		if vim.g.colorscheme == 'balance' then
			require('balance').setup()
		end
	end
}
