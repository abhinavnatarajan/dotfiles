return {
  -- colorscheme
  "folke/tokyonight.nvim",
  event = "VeryLazy",
  lazy = true,
  priority = 1000,
  version = "*",
  config = function()
    require("tokyonight").setup {
      transparent = false,
      style = "night",
      styles = {
        sidebars = "dark",
        floats = "transparent",
      },
      dim_inactive = true,
      sidebars = {"NvimTree"}
    }
    vim.cmd[[colorscheme tokyonight]]
  end
}
