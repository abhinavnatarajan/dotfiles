local M = {}

function M.silent_auto_indent()
  vim.api.nvim_feedkeys("mwggVG=`w", "t", true)
end

function M.remove_trailing_whitespace()
  local k = vim.api.nvim_replace_termcodes([[mw:%s/\v\s+$//e<CR>`w]], true, false, true)
  vim.api.nvim_feedkeys(k, "t", true)
end

function M.set_indent()
  vim.ui.select(
    {"Spaces", "Tabs"},
    {prompt = "Choose indent method"},
    function(indent_method)
      if indent_method then
        vim.ui.input(
          {prompt = "Set auto-indent width:"},
          function(input)
            local indent_w = tonumber(input)
            if indent_method == "Spaces" then
              vim.bo.expandtab = true
              vim.bo.tabstop = indent_w
              vim.bo.shiftwidth = 0
            elseif indent_method == "Tabs" then
              vim.bo.expandtab = false
              vim.bo.tabstop = indent_w
              vim.bo.shiftwidth = indent_w
            end
          end
        )
      end
    end
  )
end

return M
