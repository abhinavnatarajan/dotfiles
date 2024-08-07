local icons = require("icons")
return {
  "dstein64/nvim-scrollview",
  event = "BufWinEnter",
  cmd = {
    "ScrollViewDisable",
    "ScrollViewEnable",
    "ScrollViewToggle",
    "ScrollViewRefresh",
    "ScrollViewNext",
    "ScrollViewPrev",
    "ScrollViewFirst",
    "ScrollViewLast",
    "ScrollViewLegend"
  },
  -- this plugin is versioned but there are several unversioned commits since the last release
  -- version = "*",
  opts = {
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
    signs_on_startup = { 'all' },

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
    search_symbol = icons.ui.Search,
    spell_symbol = '~',
    textwidth_symbol = icons.ui.DoubleChevronRight,
    latestchange_symbol = icons.ui.Edit,
    trail_symbol = icons.ui.Square,
  }
}
