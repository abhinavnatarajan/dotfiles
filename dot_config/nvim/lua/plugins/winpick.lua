return {
  "abhinavnatarajan/winpick.nvim",
  event = "VeryLazy",
  config = function()
    require("winpick").setup {
      border = "rounded",
      filter = function(winid, bufid)
        if vim.api.nvim_buf_get_option(bufid, 'buftype') == "nofile" and vim.api.nvim_buf_get_option(bufid, 'filetype') ~= "alpha" then
          return false
        elseif
          vim.api.nvim_buf_get_option(bufid, 'buftype') == 'help' then
            return false
        else
          return true
        end
      end,
    }
  end
}
