return {
  "NMAC427/guess-indent.nvim",
  event = "BufReadPre", -- the plugin automatically operates on BufReadPost
  cmd = { "GuessIndent" },
  config = true
  -- this plugin is not versioned
}
