return {
  "ggandor/leap.nvim",
  event = "User FileOpened",
  config = function() 
    require("leap").add_default_mappings()
    require('leap').opts.safe_labels = {}
    local c = require("onedark.colors")
    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' }) -- or some grey
    vim.api.nvim_set_hl(0, 'LeapMatch', {
      -- For light themes, set to 'black' or similar.
      fg = 'white', bold = true, nocombine = true,
    })
    vim.api.nvim_set_hl(0, 'LeapSelected', { fg = c.black, bg = c.blue })
    vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
      fg = c.red, bold = true, nocombine = true,
    })
    vim.api.nvim_set_hl(0, 'LeapLabelSecondary', {
      fg = c.blue, bold = true, nocombine = true,
    })
  end,
}
