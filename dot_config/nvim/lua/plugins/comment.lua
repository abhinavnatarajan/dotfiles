return {
  'numToStr/Comment.nvim',
  opts = {
    -- add any options here
  },
  lazy = true,
  config = function()
    require('Comment').setup()
  end,
  event = 'User FileOpened',
  version = "*"
}
