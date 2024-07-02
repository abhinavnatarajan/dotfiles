return {
	'quarto-dev/quarto-nvim',
	ft = { 'quarto' },
	opts = {
		debug = false,
		closePreviewOnExit = true,
		lspFeatures = {
			enabled = true,
			languages = { 'r', 'python', 'julia', 'bash' },
			chunks = 'curly', -- 'curly' or 'all'
			diagnostics = {
				enabled = true,
				triggers = { "BufWritePost" }
			},
			completion = {
				enabled = true,
			},
		},
		keymap = {
			hover = nil,
			definition = nil,
			rename = nil,
			references = nil,
		}
	}
}
