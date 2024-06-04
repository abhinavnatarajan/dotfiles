return {
  "lervag/vimtex",
  lazy = false,
  version = "*",
  enabled = true,
  init = function()
    -- Use init for configuration, don't use the more common "config".
    vim.g.vimtex_fold_enabled = 0 -- use treesitter for this
    vim.g.vimtex_indent_enabled = 0
    vim.g.vimtex_indent_bib_enabled = 0
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtex_quickfix_mode = 2
    vim.g.vimtex_mappings_enabled = 1
    vim.g.vimtex_mappings_prefix = "<leader>l"
    vim.g.vimtex_imaps_enabled = 1
    vim.g.vimtex_text_obj_enabled = 1
    vim.g.vimtex_motion_enabled = 1
    vim.g.syntax_enabled = 1
    vim.g.vimtex_syntax_conceal_disable = 1
    vim.g.vimtex_view_method = 'sioyek'
  end
}
