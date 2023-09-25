return {
  "s1n7ax/nvim-window-picker",
  version = 'v2.*',
  config = function()
    require'window-picker'.setup {
      hint = "floating-big-letter",
      filter_rules = {
        include_current_win = true,
      }
    }
  end,
  lazy = true,
  event = "User FileOpened",
  version = "*",
}
