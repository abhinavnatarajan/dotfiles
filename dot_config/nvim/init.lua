-- Setup lazy.nvim for lazy loading plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Setup my config excluding plugins
table.unpack = table.unpack or unpack
require("config").setup()

-- Lazy load plugins
require("lazy").setup("plugins", {
	defaults = {
		lazy = true,
	},
	ui = {
		border = "rounded",
	},
})

-- Ensure external tools are installed
require('mason-tool-installer')

-- Setup LSP servers and attach autocomplete capabilities
require("config.LSP").setup()

-- Setup linters and hook them into the LSP client using none-ls
require('config.linters').setup()

-- Setup DAP servers and attach debugging capabilities
require("config.DAP").setup()
