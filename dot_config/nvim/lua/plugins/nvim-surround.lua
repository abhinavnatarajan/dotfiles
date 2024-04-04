return {
  'kylechui/nvim-surround', --delimiter manipulation
  version = '*',            -- Use for stability; omit to use `main` branch for the latest features
  event = 'User FileOpened',
  config = function()
    require('nvim-surround').setup({
      -- Configuration here, or leave empty to use defaults
      keymaps = {
        normal          = false,
        normal_line     = false,
        normal_cur      = false,
        normal_cur_line = false,
        insert          = false,
        insert_line     = false,
        visual          = false,
        visual_line     = false,
      },
    })
  end
}
