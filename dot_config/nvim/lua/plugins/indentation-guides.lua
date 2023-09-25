return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'User FileOpened',
  version = "v2.*",
  config = function()
    vim.opt.list = true
    vim.opt.listchars:append 'space:⋅'
    vim.opt.listchars:append 'eol:↴'
    vim.g.indent_blankline_char_list = { '|', '¦', '┆', '┊' }
    require('indent_blankline').setup({
      show_end_of_line = true,
      show_current_context = true,
      show_current_context_start = true,
      space_char_blankline = ' ',
    })
  end
}
