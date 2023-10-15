return {
  'akinsho/toggleterm.nvim',
  version = "*",
  lazy = true,
  cmd = {
    'ToggleTerm',
    'TermSelect',
    "ToggleTermSendCurrentLine",
    "ToggleTermSendVisualLines",
    "ToggleTermSendVisualSelection",
    "ToggleTermSetName",
  },
  keys = { [[<A-`>]] },
  config = function ()
    local toggleterm = require("toggleterm")
    toggleterm.setup {
      size = 70,
      open_mapping = [[<A-`>]],
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      close_on_exit = true, -- close the terminal window when the process exits
      -- Change the default shell. Can be a string or a function returning a string
      shell = vim.o.shell,
      auto_scroll = true, -- automatically scroll to the bottom on terminal output
      -- This field is only relevant if direction is set to 'float'
      shade_terminals = false,
      direction = 'vertical',
      float_opts = {
        -- The border key is *almost* the same as 'nvim_open_win'
        -- see :h nvim_open_win for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        border = "rounded",-- other options supported by win_open
        -- like `size`, width and height can be a number or function which is passed the current terminal
        -- width = <value>,
        -- height = <value>,
        winblend = 5,
        -- zindex = <value>,
      },
      winbar = {
        enabled = false,
        name_formatter = function(term) --  term: Terminal
          return term.name
        end
      },
    }
    vim.api.nvim_create_user_command("ToggleTermSendCurrentLine",
      function(opts)
        toggleterm.send_lines_to_terminal("single_line", false, opts.args)
      end,
      { nargs = "?", force = true }
    )
    vim.api.nvim_create_user_command("ToggleTermSendVisualSelection",
      function(opts)
        toggleterm.send_lines_to_terminal("visual_selection", false, opts.args)
      end,
      { range = true, nargs = "?", force = true }
    )
    vim.api.nvim_create_user_command("ToggleTermSendVisualLines",
      function(opts)
        toggleterm.send_lines_to_terminal("visual_lines", false, opts.args)
      end,
      { range = true, nargs = "?", force = true }
    )
  end
}
