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
    -- leap.opts.safe_labels = {}
    -- local c = require("onedark.colors")
    -- vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' }) -- or some grey
    -- vim.api.nvim_set_hl(0, 'LeapMatch', {
      -- For light themes, set to 'black' or similar.
    --   fg = c.green,
    --   bold = true,
    --   nocombine = true,
    -- })
    -- vim.api.nvim_set_hl(0, 'LeapSelected', { fg = c.black, bg = c.blue })
    -- vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { link = 'HopNextKey' })
    -- vim.api.nvim_set_hl(0, 'LeapLabelSecondary', { link = 'HopNextKey1' })
  end,
}
