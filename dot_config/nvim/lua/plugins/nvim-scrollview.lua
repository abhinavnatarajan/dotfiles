return {
  "dstein64/nvim-scrollview",
  event = "User FileOpened",
  config = function()
    local icons = require("icons")
    require("scrollview").setup {
      always_show = false,
      auto_mouse = true,
      base = 'right',
      column = 1,
      -- excluded_filetypes = {
      --   'NvimTree'
      -- },
      floating_windows = true,
      hover = true,
      current_only = true,
      signs_on_startup = {'all'},

      -- sign symbols
      conflicts_bottom_symbol = '>',
      conflicts_middle_symbol = '=',
      conflicts_top_symbol = '<',
      cursor_symbol = icons.ui.BoldArrowRight,
      diagnostics_error_symbol = icons.diagnostics.Error,
      diagnostics_hint_symbol = icons.diagnostics.Hint,
      diagnostics_info_symbol = icons.diagnostics.Information,
      diagnostics_warn_symbol = icons.diagnostics.Warning,
      folds_symbol = icons.ui.TriangleShortArrowRight,
      loclist_symbol = icons.ui.LocationList,
      quickfix_symbol = icons.ui.Fix,
      search_symbol = icons.ui.Circle,
      spell_symbol = '~',
      textwidth_symbol = icons.ui.DoubleChevronRight,
      trail_symbol = icons.ui.Square,
    }
  end
}
