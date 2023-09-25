return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "tokyonight.nvim" },
  event = "VimEnter",
  config = function()
    local icons = require("icons")
    require("lualine").setup {
      theme = "tokyonight-night",
      extensions = {
        "nvim-tree",
        "lazy",
        "fzf",
        "toggleterm",
        "quickfix",
        "nvim-dap-ui",
        "trouble"
      },
      options = {
        disabled_filetypes = {
          winbar = {"NvimTree", "alpha" },
          statusline = {"alpha"},
        },
        component_separators = { left = icons.ui.RoundDividerRight, right = icons.ui.RoundDividerLeft},
        section_separators = { left = icons.ui.BoldRoundDividerRight, right = icons.ui.BoldRoundDividerLeft},
      },
      winbar = {
        lualine_c = {
          {
            function()
              local navic = require("nvim-navic")
              if navic.is_available() and navic.get_location() ~= "" then
                return navic.get_location()
              else
                return "[Active]"
              end
            end,
          },
        },
      },
      inactive_winbar = {
        lualine_c = {
          {
            function()
              local navic = require("nvim-navic")
              if navic.is_available() and navic.get_location() ~= "" then
                return navic.get_location()
              else
                return "[Inactive]"
              end
            end,
          },
        },
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {
          'branch',
          'diff',
          {
            'diagnostics',
            sources = { 'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic' },
            symbols = {
              error = icons.diagnostics.BoldError .. ' ',
              warn = icons.diagnostics.BoldWarning .. ' ',
              info = icons.diagnostics.BoldInformation .. ' ',
              hint = icons.diagnostics.BoldHint .. ' ',
            },
            always_visible = true,
          },
        },
        lualine_c = {
          function() return "cwd: " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~:.:gs%\\v(\\.?[^/]{0,2})[^/]*/%\\1/%") end,
          function() return "file: " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t") end,
        },
        lualine_x = {
          function()
            if vim.bo.expandtab then
              if vim.bo.shiftwidth == 0 then
                return "Space=" .. tostring(vim.bo.tabstop)
              else
                return "Space=" .. tostring(vim.bo.shiftwidth)
              end
            else
              return "Tab="..tostring(vim.bo.tabstop)
            end
          end
        },
        lualine_y = {'encoding', 'fileformat', 'filetype'},
        lualine_z = {
          { "location"},
        }
      },
    }
  end
}
