return {
  'kevinhwang91/nvim-hlslens', --improved search
  name = 'hlslens',
  version = "*",
  event = 'VimEnter',
  config = function()
    require('hlslens').setup {
      auto_enable = true,
      calm_down = false,
      enable_incsearch = true, 
    }
  end
}
