return {
  'rcarriga/nvim-notify',
  cmd = 'VeryLazy',
  version = "*",
  -- dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<F15>",
      function()
        require('notify').dismiss({ pending = true, silent = true })
      end,
      desc = "Dismiss notifications",
      mode = { "n", "i", "v", "o" }
    }
  },
  config = function()
    if package.loaded["telescope"] then
      require("telescope").load_extension("notify")
    end
  end
}
