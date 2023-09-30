return {
  "dstein64/nvim-scrollview",
  event = "User FileOpened",
  config = function()
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
    }
  end
}
