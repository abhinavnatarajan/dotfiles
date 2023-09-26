return {
  'goolord/alpha-nvim',
  config = function ()
    local alpha = require( 'alpha' )
    local dashboard = require( 'alpha.themes.dashboard' )
    local icons = require('icons')
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }
    dashboard.section.buttons.val = {
      dashboard.button( "n", icons.ui.NewFile .. " New file" , ":lua ene | startinsert <CR>", { desc = 'New file' }),
      dashboard.button( "f", icons.ui.FindFile .. " Find files", [[:lua require("telescope.builtin").find_files()<CR>]], { desc = 'Find files' }),
      dashboard.button( "r", icons.ui.History .. " Recent files", [[:lua require("telescope_custom_pickers").oldfiles()<CR>]], { desc = 'Recent files' }),
      dashboard.button( "g", icons.ui.FindText .. " Search text", [[:lua require("telescope_custom_pickers").live_grep()<CR>]], { desc = "Search text"}),
      dashboard.button( "d", icons.ui.Folder .. " Browse directories", ":Telescope file_browser<CR>", { desc = 'Browse files' }),
      dashboard.button( "k", icons.ui.Project .. " Find workspace", [[:lua require("telescope_custom_pickers").workspaces()<CR>]], { desc = 'Find workspace' }),
      dashboard.button( "s", icons.ui.Gear .. " Configuration" , [[:lua require("telescope_custom_pickers").config()<CR>]], {desc = 'Browse config files'}),
      dashboard.button( "q", icons.ui.SignOut .. " Quit NVIM", "<CMD>confirm qa<CR>"),
    }
    alpha.setup(dashboard.config)
  end,
  event= 'VeryLazy',
  -- cmd = "Alpha"
}
