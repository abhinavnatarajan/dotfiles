local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Default settings
require("settings").load_defaults()

-- Lazy load plugins
require("lazy").setup {
  spec = "plugins",
  ui = {
    border = "rounded"
  }
}

-- Setup autocompletion and snippet sources
require("autocomplete_tools").setup()

-- Setup LSP servers and attach autocomplete capabilities
require("lsp_tools").setup()

-- Keybindings
require("keybinds").load_defaults()

-- Events and callbacks
require("autocmds").load_defaults()
