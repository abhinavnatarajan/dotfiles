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
      gc = "Comments",
    },
    key_labels = {
      ["<cr>"] = require("icons").ui.ReturnCharacter,
      ["<tab>"] = require("icons").ui.TabCharacter,
      ["<space>"] = require("icons").ui.SpaceCharacter,
    },
    motions = {
      count = true,
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>",   -- binding to scroll up inside the popup
    },
    window = {
      border = "rounded",        -- none, single, double, shadow
      position = "bottom",      -- bottom, top
      margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
      padding = { 0, 1, 0, 1 }, -- extra window padding [top, right, bottom, left]
      winblend = 8,             -- value between 0-100 0 for fully opaque and 100 for fully transparent
      zindex = 1000,            -- positive value to position WhichKey above other floating windows.
    },
    layout = {
      height = { min = 4, max = 25 },                                                 -- min and max height of the columns
      width = { min = 20, max = 50 },                                                 -- min and max width of the columns
      spacing = 3,                                                                    -- spacing between columns
      align = "left",                                                                 -- align columns left, center or right
    },
    ignore_missing = false,                                                           -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
    show_help = true,                                                                 -- show a help message in the command line for using WhichKey
    show_keys = true,                                                                 -- show the currently pressed key and its label as a message in the command line
    triggers = "auto",                                                                -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specifiy a list manually
    -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
    triggers_nowait = {
      -- marks
      "`",
      "'",
      "g`",
      "g'",
      -- registers
      '"',
      "<c-r>",
      -- spelling
      "z=",
    },
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for keymaps that start with a native binding
      i = { "j", "k" },
      v = { "j", "k" },
    },
    -- disable the WhichKey popup for certain buf types and file types.
    -- Disabled by default for Telescope
    disable = {
      buftypes = {},
      filetypes = { 'Alpha' },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    for _, mapping in pairs(vim.g.which_key_defaults) do
      wk.register(mapping)
    end
  end
}
