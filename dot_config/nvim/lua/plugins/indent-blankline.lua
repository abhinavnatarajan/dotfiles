return {
	'lukas-reineke/indent-blankline.nvim',
	dependencies = {'nvim-treesitter/nvim-treesitter'},
	event = 'User FileOpened',
	version = "v3.*",
	config = function()
		require('ibl').setup {
			indent = {
				char = { '╎', '┆', '┊', '│' },
				tab_char = { '╎', '┆', '┊', '│' },
			},
			whitespace = {
				highlight = 'Whitespace',
			},
			scope = {
				enabled = true,
				char = '│',
				show_start = true,
				show_end = false,
				exclude = {
					node_type = {
						lua = nil,
					}
				}
			}
		}
	end
}
