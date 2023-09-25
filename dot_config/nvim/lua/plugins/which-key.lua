return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  cmd = 'WhichKey',
  version = "*",
  config = function()
    require('which-key').setup {
      disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt", 'Alpha' },
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
      motions = {
        count = true,
      },
      window = {
        border = "rounded",
      }
    }
  end
}
