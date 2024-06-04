return {
  'karb94/neoscroll.nvim', --smooth scrolling
  event = 'User FileOpened',
  version = "*",
  keys = {
    {
      "<C-y>",
      function()
        require("neoscroll").scroll(-0.1, true, 100)
      end,
      require("icons").ui.ChevronUp .. " Scroll up 10% of window height",
      mode = { "n", "i", "x", "o" },
    },
    {
      "<C-u>",
      function()
        if not require("noice.lsp").scroll(-4) then
          require("neoscroll").scroll(-vim.wo.scroll, true, 100)
        end
      end,
      desc = require("icons").ui.ChevronDoubleUp .. " Scroll up",
      mode = { "n", "i", "x", "o" },
    },
    {
      "<C-e>",
      function()
        require("neoscroll").scroll(0.1, true, 100)
      end,
      desc = require("icons").ui.ChevronDown .. " Scroll down 10% of window height",
      mode = { "n", "i", "x", "o" },
    },
    {
      "<C-d>",
      function()
        if not require("noice.lsp").scroll(4) then
          require("neoscroll").scroll(vim.wo.scroll, true, 100)
        end
      end,
      desc = require("icons").ui.ChevronDoubleDown .. " Scroll down",
      mode = { "n", "i", "x", "o" },
    },
    {
      "<PageUp>",
      function()
        require("neoscroll").scroll(-vim.api.nvim_win_get_height(0), true, 100)
      end,
      desc = require("icons").ui.ChevronTripleUp .. " Page up",
      mode = { "n", "i", "x", "o" },
    },
    {
      "<PageDown>",
      function()
        require("neoscroll").scroll(vim.api.nvim_win_get_height(0), true, 100)
      end,
      desc = require("icons").ui.ChevronTripleDown .. " Page down",
      mode = { "n", "i", "x", "o" },
    },
    ["zz"] = {
      function()
        require("neoscroll").zz(200)
      end,
      "Centre cursor line in window",
    },
    ["zt"] = {
      function()
        require("neoscroll").zt(200)
      end,
      desc = "Align cursor line with top of window",
    },
    {
      "zb",
      function()
        require("neoscroll").zb(200)
      end,
      desc = "Align cursor line with bottom of window",
    },
  },
  opts = {
    -- All these keys will be mapped to their corresponding default scrolling animation
    easing = "quadratic",
    mappings = {},
    hide_cursor = true,          -- hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil,       -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
    performance_mode = false,    -- Disable 'Performance Mode' on all buffers.
  },
}
