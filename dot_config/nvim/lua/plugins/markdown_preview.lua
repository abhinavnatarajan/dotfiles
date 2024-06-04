return {
	"iamcco/markdown-preview.nvim",
	build = function() vim.fn["mkdp#util#install"]() end,
	cmd = {
		"MarkdownPreviewToggle",
		"MarkdownPreview",
		"MarkdownPreviewStop"
	},
	-- this plugin is versioned but has severa bugfixes since the last release
	ft = { "markdown" },
	keys = {
		"<Plug>(MarkdownPreview)",
		"<Plug>(MarkdownPreviewStop)",
		"<Plug>(MarkdownPreviewToggle)"
	}
}
