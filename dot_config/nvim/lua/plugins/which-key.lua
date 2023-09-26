return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  cmd = 'WhichKey',
  version = "*",
  config = function()
    local icons = require("icons")
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
      icons = {
        breadcrumb = icons.ui.DividerRight, -- symbol used in the command line area that shows your active key combo
        separator = "", -- symbol used between a key and it's label
        group = "", -- symbol prepended to a group
      },
      key_labels = {
        ["<cr>"] = icons.ui.ReturnCharacter,
        ["<tab>"] = icons.ui.TabCharacter,
        ["<space>"] = icons.ui.SpaceCharacter,
      },
      motions = {
        count = true,
      },
      window = {
        border = "rounded",
        winblend = 5,
      }
    }
  end
}
