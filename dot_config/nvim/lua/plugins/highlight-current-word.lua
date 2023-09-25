return {
  'RRethy/vim-illuminate',
  event = 'User FileOpened',
  config = function()
    require("illuminate").configure {
      filetypes_denylist = {
        "NvimTree",
        "alpha",
        "Trouble",
        "mason",
      }
    }
  end,
}
