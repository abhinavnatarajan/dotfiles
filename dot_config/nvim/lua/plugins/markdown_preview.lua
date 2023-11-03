return {
	"iamcco/markdown-preview.nvim",
	build = function() vim.fn["mkdp#util#install"]() end,
	cmd = {
		"MarkdownPreviewToggle",
		"MarkdownPreview",
		"MarkdownPreviewStop"
	},
	-- ft = { "markdown" },
	keys = {
		"<Plug>(MarkdownPreview)",
		"<Plug>(MarkdownPreviewStop)",
		"<Plug>(MarkdownPreviewToggle)"
	}
}
