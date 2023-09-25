return {
  'petertriho/nvim-scrollbar', --searchbar with diagnostics
  event = 'User FileOpened',
  config = function()
    require('scrollbar').setup({
      handlers = {
        gitsigns = true,
        search = true,
      }
    })
  end
}
