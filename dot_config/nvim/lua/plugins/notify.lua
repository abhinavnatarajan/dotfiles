return {
  'rcarriga/nvim-notify',
  lazy = true,
  cmd = 'VeryLazy',
  version = "*",
  -- dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    -- require('notify').setup {
    --   timeout = 2500,
    --   render = 'default'
    -- }
    if package.loaded["telescope"] then
      require("telescope").load_extension("notify")
    end
  end
}
