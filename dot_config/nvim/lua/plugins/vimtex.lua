return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    -- Use init for configuration, don't use the more common "config".
    vim.g.vimtex_fold_enabled = 0 -- use treesitter for this
    vim.g.vimtex_indent_enabled = 1
    vim.g.vimtex_indent_bib_enabled = 1
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtex_quickfix_mode = 2
    vim.g.syntax_enabled = 1
    -- vim.g.vimtex_quickfix_method = 'loglatex'
    -- vim.g.vimtex_syntax_conceal = {
    --   accents = 1,
    --   ligatures = 1,
    --   cites = 0,
    --   fancy = 1,
    --   spacing = 0,
    --   greek = 1,
    --   math_bounds = 0,
    --   math_delimiters = 1,
    --   math_fracs = 1,
    --   math_super_sub = 0,
    --   sections = 0,
    --   styles = 0,
    -- }
    vim.g.vimtex_syntax_conceal_disable = 1
    vim.g.vimtex_view_method = 'sioyek'
    -- vim.g.vimtex_syntax_custom_cmds = {
    --   {
    --     name = 'RR',
    --     mathmode = 1,
    --     concealchar = 'ℝ'
    --   },
    --   {
    --     name = 'QQ',
    --     mathmode = 1,
    --     concealchar = 'ℚ'
    --   },
    --   {
    --     name = 'CC',
    --     mathmode = 1,
    --     concealchar = 'ℂ'
    --   },
    --   {
    --     name = 'NN',
    --     mathmode = 1,
    --     concealchar = 'ℕ'
    --   },
    --   {
    --     name = 'ZZ',
    --     mathmode = 1,
    --     concealchar = 'ℤ'
    --   },
    --   {
    --     name = 'PP',
    --     mathmode = 1,
    --     concealchar = 'ℙ'
    --   },
    --   {
    --     name = 'FF',
    --     mathmode = 1,
    --     concealchar = '𝔽'
    --   },
    --   {
    --     name = 'HH',
    --     mathmode = 1,
    --     concealchar = 'ℍ'
    --   },
    --   {
    --     name = 'TT',
    --     mathmode = 1,
    --     concealchar = '𝕋'
    --   },
    -- }
  end
}
