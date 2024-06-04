return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  cmd = 'WhichKey',
  version = "*",
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20.
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt", 'Alpha' },
    },
    operators = {
      d = "Delete",
      c = "Change",
      y = "Yank",
      ["g~"] = "Toggle case",
      ["gu"] = "Lowercase",
      ["gU"] = "Uppercase",
      ["zf"] = "Create fold",
      ["!"] = "Filter though external program",
      -- ["v"] = "Visual Character Mode",
      gc = "Comments"
    },
    icons = {
      breadcrumb = require("icons").ui.DividerRight,   -- symbol used in the command line area that shows your active key combo
      separator = "",                                  -- symbol used between a key and it's label
      group = "",                                      -- symbol prepended to a group
    },
    key_labels = {
      ["<cr>"] = require("icons").ui.ReturnCharacter,
      ["<tab>"] = require("icons").ui.TabCharacter,
      ["<space>"] = require("icons").ui.SpaceCharacter,
    },
    motions = {
      count = true,
    },
    window = {
      border = "rounded",
      margin = { 0, 0, 0, 0 },    -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
      padding = { 0, 0, 0, 0 },   -- extra window padding [top, right, bottom, left]
      winblend = 5,               -- value between 0-100 0 for fully opaque and 100 for fully transparent
      zindex = 1000,              -- positive value to position WhichKey above other floating windows.
    },
    layout = {
      height = { min = 4, max = 10 },   -- min and max height of the columns
      width = { min = 20, max = 50 },   -- min and max width of the columns
      spacing = 3,                      -- spacing between columns
      align = "left",                   -- align columns left, center or right
    },
    triggers_nowait = {
      "z=",
    },
    triggers_blacklist = {
      i = { "j", "k" },
      v = { "j", "k" },
    }
  }
}
