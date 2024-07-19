return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  cmd = 'WhichKey',
  version = "*",
  opts = {
    preset = "modern",
    notify = false,
    triggers = {
      "<auto>", mode = "nisotc"
    },
    win = {
      no_overlap = false,
      padding = {0, 0},
      height = { max = vim.o.lines * 0.3 },
      wo = {
        winblend = 8
      }
    },
    layout = {
      width = { min = 20, max = 40 },   -- min and max width of the columns
    },
    icons = {
      separator = "➜",
      colors = false,
      rules = false,
    }
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add(require("config.keybinds").which_key_defaults)
  end
}
