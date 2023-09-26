return {
  "s1n7ax/nvim-window-picker",
  version = "*",
  lazy = true,
  event = "User FileOpened",
  config = function()
    require"window-picker".setup {
      hint = "floating-big-letter",
      filter_func = function(win_ids, filts)
        local wins = {}
        for i, w in pairs(win_ids) do
          local buf = vim.api.nvim_win_get_buf(w)
          if vim.api.nvim_buf_get_options(buf, 'buftype') ~= "nofile" or vim.api.nvim_buf_get_options(buf, 'filetype') == 'alpha' then
                wins[#wins + 1] = w
          end
        end
        print(vim.inspect(filts))
        return wins
      end,
      filter_rules = {
        include_current_win = true,
        bo = {
          filetype = {
            "NvimTree",
            "notify",
            "toggleterm",
            "Trouble",
            "lazy",
            "lspinfo",
            "mason",
            "noice",
          },
          buftype = {
            "terminal",
            "help",
          },
        },
      },
    }
  end,
}
