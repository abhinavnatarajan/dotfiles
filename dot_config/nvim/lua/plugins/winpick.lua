return {
  "abhinavnatarajan/winpick.nvim",
  event = "VeryLazy",
  config = function()
    require("winpick").setup {
      border = "rounded",
      filter = function(winid, bufid)
        local exclude_buftypes = {
          help = true,
          terminal = true,
          nofile = true,
        }
        if vim.api.nvim_buf_get_option(bufid, 'filetype') == "alpha" then
          return true
        elseif not exclude_buftypes[vim.api.nvim_buf_get_option(bufid, 'buftype')] then
          return true
        else
          return false
        end
      end,
    }
  end
}
