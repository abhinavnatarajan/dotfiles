return {
  "NMAC427/guess-indent.nvim",
  event = "BufReadPre", -- the plugin automatically operates on BufReadPost
  cmd = { "GuessIndent" },
  keys = {
    {
      "<leader>fI",
      "<CMD>silent GuessIndent<CR>",
      desc = require('icons').ui.Indent .. " Guess buffer indent",
    }
  },
  config = true
  -- this plugin is not versioned
}
