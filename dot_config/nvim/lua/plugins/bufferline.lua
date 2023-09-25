-- use a tab row to display open buffers
return {
  'akinsho/bufferline.nvim',
  lazy = true,
  event = 'User FileOpened',
  version = '*',
  dependencies = { "tokyonight.nvim", 'nvim-tree/nvim-web-devicons' },
  config = function()
    local bufferline = require('bufferline')
    bufferline.setup {
      options = {
        themable = true,
        -- numbers = 'ordinal',
        style_preset = bufferline.style_preset.no_italic,
        diagnostics = 'nvim_lsp',
        tab_size = 14,
        close_command = ':Bdelete %d',
        right_mouse_command = ':Bdelete %d',
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true, -- for tabpages
        show_tab_indicators = true,
        move_wraps_at_ends = false, -- moving buffers wraps around at ends
        enforce_regular_tabs = false, -- enforce all visual tabs have same size
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'Explorer',
            text_align = 'center',
            separator = true
          }
        },
        -- separator_style = 'slant',
        always_show_bufferline = true,
        sort_by = 'insert_at_end'
      }
    }
  end
}
