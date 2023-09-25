return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "BurntSushi/ripgrep",
    {
      'nvim-telescope/telescope-file-browser.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      lazy = true,
    },
    { 
      'nvim-telescope/telescope-fzf-native.nvim', 
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      lazy = true,
    },
    "tsakirist/telescope-lazy.nvim",
    -- "rmagatti/auto-session",
  },
  lazy = true,
  cmd = 'Telescope',
  config = function()
    local telescope = require('telescope')
    telescope.setup {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          mirror =  false,
        },
        wrap_results = true,
        winblend = 5,
      },
      extensions = {
        file_browser = {
          hijack_netrw = true,
          hidden = {
            file_browser = true,
            folder_browser = true,
          },
          collapse_dirs = true,
          use_fd = true,
          git_status = true,
          prompt_path = true
        },
        fzf = {
          case_mode = "ignore_case",
        },
        lazy = {
          theme = "ivy",
        },
        notify = {
          timeout = 2500,
          render = 'default'
        },
      },
    }
    telescope.load_extension("file_browser")
    telescope.load_extension("fzf")
    telescope.load_extension("lazy")
    if package.loaded["notify"] then
      telescope.load_extension("notify")
    end
  end,
}
