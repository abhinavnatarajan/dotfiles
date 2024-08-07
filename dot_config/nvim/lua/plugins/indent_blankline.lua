return {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "BufWinEnter",
  version = "*",
  main = "ibl",
  opts = {
    indent = {
      char = { "╎", "┆", "┊", "│" },
      tab_char = { "╎", "┆", "┊", "│"},
      -- char = { "╏", "┇", "┋", "┃" },
      -- tab_char = { "╏", "┇", "┋", "┃" },
      smart_indent_cap = true,
      repeat_linebreak = true
    },
    whitespace = {
      highlight = "Whitespace",
    },
    scope = {
      enabled = true,
      char = "│",
      show_start = true,
      show_end = false,
      exclude = {
        node_type = {
          lua = nil,
        },
      },
    },
  },
}
