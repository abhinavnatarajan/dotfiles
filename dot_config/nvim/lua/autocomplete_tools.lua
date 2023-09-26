local M = {}

function M.setup()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local icons = require("icons")
  local select_opts = {behaviour = cmp.SelectBehavior.Select}
  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      completion = {
        border = "rounded",
      },
      documentation = {
        border = "rounded"
      }
    },
    preselect = cmp.PreselectMode.None,
    mapping = {
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      -- ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
      -- ['<Down>'] = cmp.mapping.select_next_item(select_opts),
      ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
      ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
      -- set <C-Space> as the autocomplete trigger key
      ['<C-Space>'] = cmp.mapping(function(_)
        if cmp.visible() then
          cmp.abort()
        else
          cmp.complete()
        end
      end, {'i'}),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

      -- If the completion menu is visible, move to the next item.
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item(select_opts)
        else
          fallback()
        end
      end, {'i', 's'}),
      -- If the completion menu is visible, move to the previous item.
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item(select_opts)
        else
          fallback()
        end
      end, {'i', 's'}),
      -- Jump to the next placeholder in the snippet
      ['<C-f>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, {'i', 's'}),
      -- Jump to the previous placeholder in the snippet
      ['<C-b>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {'i', 's'}),
    },
    sources = cmp.config.sources(
      {
        { name = 'nvim_lsp' },
        -- { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' }, -- For luasnip users.
      },
      {
        { name = 'buffer' }
      }
    ),
    formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
        local menu_icon = {
          nvim_lsp = icons.ui.Lightbulb,
          luasnip = icons.ui.Code,
          buffer = icons.ui.CodeFile,
          path = icons.ui.Path,
          cmdline = icons.ui.ChevronRight,
        }

        item.menu = menu_icon[entry.source.name]
        return item
      end,
    },
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources(
      {
        { name = 'git' },
      }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
      {
        { name = 'buffer' },
      }
    )
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{ name = 'buffer' },},
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':',
    {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
        {
          {
            name = 'path' ,
            option = {
              trailing_slash = true,
              label_trailing_slash = true,
              -- get_cwd = vim.fn.getcwd
            },
          },
        },
        {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            },
          },
        }
      )
    }
  )
  require("cmp_git").setup()
end

return M
