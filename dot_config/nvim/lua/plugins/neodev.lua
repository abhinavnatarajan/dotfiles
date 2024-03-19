return {
  "folke/neodev.nvim",
  version = "*",
  config = function()
    require("neodev").setup{
      library = { plugins = { "nvim-dap-ui" }, types = true },
    }
  end,
  lazy = true
}
