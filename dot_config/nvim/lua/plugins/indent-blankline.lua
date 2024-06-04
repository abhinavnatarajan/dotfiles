return {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "User FileOpened",
  version = "*",
  main = "ibl",
  opts = {
    indent = {
      char = { "╎", "┆", "┊", "│" },
      tab_char = { "╎", "┆", "┊", "│" },
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
