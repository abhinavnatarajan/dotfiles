return {
  'kevinhwang91/nvim-hlslens', --improved search
  name = 'hlslens',
  version = "*",
  -- event = 'User FileOpened',
  -- init = function()
    -- local kopts = {noremap = true, silent = true}
    -- vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
    -- vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
    -- vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    -- vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    -- vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    -- vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    -- vim.keymap.set('n', '<Leader>l', '<Cmd>noh<CR>', kopts)
  -- end,
  config = function()
    -- require('hlslens').setup()
    require("scrollbar.handlers.search").setup{}
  end
}
