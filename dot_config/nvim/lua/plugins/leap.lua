return {
  "ggandor/leap.nvim",
  event = "User FileOpened",
  config = function()
    local leap = require("leap")
    leap.opts.highlight_unlabeled_phase_one_targets = false
    -- leap.opts.safe_labels = {}
    local c = require("onedark.colors")
    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' }) -- or some grey
    vim.api.nvim_set_hl(0, 'LeapMatch', {
      -- For light themes, set to 'black' or similar.
      fg = c.green, bold = true, nocombine = true,
    })
    vim.api.nvim_set_hl(0, 'LeapSelected', { fg = c.black, bg = c.blue })
    vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { link = 'HopNextKey' })
    vim.api.nvim_set_hl(0, 'LeapLabelSecondary', { link = 'HopNextKey1' })
  end,
}
-- return {
--   "smoka7/hop.nvim",
--   version = "*",
--   config = function() 
--     require("hop").setup{}
--   end
-- }
