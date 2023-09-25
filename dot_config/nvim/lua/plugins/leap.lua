return {
  "ggandor/leap.nvim",
  event = "User FileOpened",
  config = function() require("leap").add_default_mappings() end,
}
