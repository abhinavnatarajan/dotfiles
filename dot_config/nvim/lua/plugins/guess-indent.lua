return {
  "NMAC427/guess-indent.nvim",
  event = "User FileOpened",
  lazy = true,
  config = function() require("guess-indent").setup {} end
}
