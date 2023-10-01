return {
  "sainnhe/sonokai",
  event = "VeryLazy",
  priority = 1000,
  -- optional = true,
  config = function()
    vim.g.sonokai_style = "atlantis"
    vim.g.sonokai_better_performance = 1
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_disable_italic_comment = 0
    vim.g.sonokai_dim_inactive_windows = 0
    vim.g.sonokai_show_eob = 0
    vim.g.sonokai_float_style = "dim"-- or "dim",
    -- vim.cmd [[ colorscheme sonokai ]]
  end,
}
