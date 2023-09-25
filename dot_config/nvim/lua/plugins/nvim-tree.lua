return {
  'nvim-tree/nvim-tree.lua',
  lazy = true,
  cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFocus', 'NvimTreeFindFileToggle' },
  event = "User DirOpened",
  dependencies = { "s1n7ax/nvim-window-picker" },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  config = function()
    require('nvim-tree').setup {
      sort_by = 'name',
      hijack_cursor = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = false,
      select_prompts = true,
      -- prefer_startup_root = false,
      hijack_netrw = true,
      update_focused_file = {
        enable = false,
        debounce_delay = 15,
        update_root = false,
        ignore_list = {},
      },
      filters = {
        dotfiles = false,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 50,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      git = {
        enable = true,
        ignore = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        timeout = 200,
      },
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true
      },
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {},
      },
      view = {
        centralize_selection = false,
        width = 40,
        side = "right",
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        float = {
          enable = false,
          quit_on_focus_loss = true,
          open_win_config = {
            relative = "editor",
            border = "rounded",
            width = 30,
            height = 30,
            row = 1,
            col = 1,
          },
        },
      },
      renderer = {
        add_trailing = false,
        group_empty = true,
        highlight_git = true,
        full_name = false,
        highlight_opened_files = "name",
        highlight_diagnostics = false,
        highlight_modified = 'name',
        root_folder_label = ":t",
        indent_width = 2,
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = '-',
            none = " ",
          },
        },
        icons = {
          webdev_colors = true,
          git_placement = 'after',
          modified_placement = 'after',
          diagnostics_placement = "after",
        },
        special_files = {
          'Cargo.toml',
          'pyproject.toml',
          'Makefile',
          'CMakeLists.txt',
          'Project.toml',
          'Manifest.toml',
          'README.md',
          'README.rst',
          'readme.md',
          'readme.rst',
          'vcpkg.json',
          '.gitignore'
        }
      },
      trash = {
        cmd = "trash",
        require_confirm = true,
      },
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = true,
          restrict_above_cwd = false,
        },
        expand_all = {
          max_folder_discovery = 300,
          exclude = { '.git' },
        },
        file_popup = {
          open_win_config = {
            col = 1,
            row = 1,
            relative = "cursor",
            border = "shadow",
            style = "minimal",
          },
        },
        open_file = {
          quit_on_open = false,
          resize_window = false,
          window_picker = {
            enable = true,
            picker = require('window-picker').pick_window,
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = {
          close_window = false,
        },
      },
      tab = {
        sync = {
          open = false,
          close = false,
          ignore = {},
        },
      },
      notify = {
        threshold = vim.log.levels.INFO,
      },
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = true,
      },
      ui = {
        confirm = {
          remove = true,
          trash = true
        }
      },
      log = {
        enable = false,
        truncate = false,
        types = {
          all = false,
          config = false,
          copy_paste = false,
          dev = false,
          diagnostics = false,
          git = false,
          profile = false,
          watcher = false,
        },
      },
    }
  end
}
