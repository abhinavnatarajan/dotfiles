-- use a tab row to display open buffers
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = {
    -- "tokyonight.nvim",
    "navarasu/onedark.nvim",
    -- "sainnhe/sonokai",
    "nvim-tree/nvim-web-devicons",
    "abhinavnatarajan/winpick.nvim",
  },
  cmd = {
    "BufferLinePick",
    "BufferLineTogglePin",
    "BufferLineCyclePrev",
    "BufferLineCycleNext",
    "BufferLineMovePrev",
    "BufferLineMoveNext"
  },
  event = "BufWinEnter",
  keys = {
    { "<leader>bj", "<CMD>BufferLinePick<CR>",      desc = require("icons").ui.GotoFile .. " Jump to buffer", },
    { "<leader>bp", "<CMD>BufferLineTogglePin<CR>", desc = require("icons").ui.Pin .. " Pin buffer", },
    {
      "<A-h>",
      "<CMD>BufferLineCyclePrev<CR>",
      desc = require("icons").ui.ChevronLeftCircleOutline .. " Previous buffer",
      mode = { "n", "i" },
    },
    {
      "<A-l>",
      "<CMD>BufferLineCycleNext<CR>",
      desc = require("icons").ui.ChevronRightCircleOutline .. " Next buffer",
      mode = { "n", "i" },
    },
    {
      "<A-H>",
      "<CMD>BufferLineMovePrev<CR>",
      desc = require("icons").ui.ChevronLeftCircle .. " Move buffer left",
      mode = { "n", "i" },
    },
    {
      "<A-L>",
      "<CMD>BufferLineMoveNext<CR>",
      desc = require("icons").ui.ChevronRightCircle .. " Move buffer right",
      mode = { "n", "i" },
    },
  },
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
        left_mouse_command = function(bufnr)
          local window = require('utils.windows').get_window()
          vim.api.nvim_set_current_win(window)
          vim.api.nvim_win_set_buf(window, bufnr)
        end,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true, -- for tabpages
        color_icons = true,
        indicator = {
          style = 'icon',
          icon = '▎',
        },
        separator_style = "thick",
        show_tab_indicators = true,
        move_wraps_at_ends = false,   -- moving buffers wraps around at ends
        enforce_regular_tabs = false, -- enforce all visual tabs have same size
        persist_buffer_sort = true,
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'Explorer',
            text_align = 'center',
            separator = true
          }
        },
        always_show_bufferline = true,
        sort_by = 'insert_at_end'
      }
    }
  end
}
