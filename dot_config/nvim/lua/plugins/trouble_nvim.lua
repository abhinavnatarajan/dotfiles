return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  event = { "LspAttach", "QuickFixCmdPre" },
  cmd = { "TroubleToggle" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    win_config = { border = "rounded", focusable = true },
    auto_fold = true,
    use_diagnostic_signs = true,
  },
}
