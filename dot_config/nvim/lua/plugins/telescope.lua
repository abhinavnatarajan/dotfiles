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
    "debugloop/telescope-undo.nvim",
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
        winblend = (vim.g.neovide and 25) or 5,
        get_selection_window = require("utils.windows").get_window
      },
      pickers = {
        help_tags = {
          mappings = {
            i = {
              ["<CR>"] = "select_vertical"
            },
            n = {
              ["<CR>"] = "select_vertical"
            },
          }
        },
        find_files = {
          no_ignore = true,
        },
        git_files = {
          no_ignore = true,
        },
        live_grep = {
          prompt_title = "Search text",
        },
        oldfiles = {
          prompt_title = "Recent files"
        }
      },
      extensions = {
        file_browser = {
          hijack_netrw = true,
          use_fd = true,
          respect_gitignore = false,
          hidden = {
            file_browser = true,
            folder_browser = true,
          },
          collapse_dirs = false,
          git_status = true,
          prompt_path = true
        },
        undo = {
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
    telescope.load_extension("undo")
    if package.loaded["noice"] then
      telescope.load_extension("noice")
    end
  end,
}
