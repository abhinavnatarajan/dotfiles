return {
  "ggandor/leap.nvim",
  keys   = {
    { "g<space>",   "<Plug>(leap-forward)",       desc = require("icons").ui.BoldArrowRight .. " Leap forward",      mode = { "n", "x", "o" } },
    { "g<S-space>", "<Plug>(leap-backward)",      desc = require("icons").ui.BoldArrowLeft .. " Leap backward",      mode = { "n", "x", "o" } },
    { "g<Tab>",     "<Plug>(leap-forward-till)",  desc = require("icons").ui.BoldArrowRight .. " Leap forward till", mode = { "n", "x", "o" } },
    { "g<S-Tab>",   "<Plug>(leap-backward-till)", desc = require("icons").ui.BoldArrowLeft .. " Leap backward till", mode = { "n", "x", "o" } },
  },
  config = function()
    local leap = require("leap")
    leap.opts.highlight_unlabeled_phase_one_targets = true
    vim.api.nvim_set_hl(0, 'LeapLabel', { link = 'IncSearch' })
    vim.api.nvim_set_hl(0, 'LeapMatch', { link = 'Search' })
  end,
}
