return {
  'SmiteshP/nvim-navic',
  dependencies = { 'neovim/nvim-lspconfig' },
  event = "User FileOpened",
  config = function()
    local icons = require("icons")
    require("nvim-navic").setup {
      icons = {
        File          = icons.syntax.File .. " ",
        Module        = icons.syntax.Module .. " ",
        Namespace     = icons.syntax.Namespace .. " ",
        Package       = icons.syntax.Package .. " ",
        Class         = icons.syntax.Class .. " ",
        Method        = icons.syntax.Method .. " ",
        Property      = icons.syntax.Property .. " ",
        Field         = icons.syntax.Field .. " ",
        Constructor   = icons.syntax.Constructor .. " ",
        Enum          = icons.syntax.Enum .. " ",
        Interface     = icons.syntax.Interface .. " ",
        Function      = icons.syntax.Function .. " ",
        Variable      = icons.syntax.Variable .. " ",
        Constant      = icons.syntax.Constant .. " ",
        String        = icons.syntax.String .. " ",
        Number        = icons.syntax.Number .. " ",
        Boolean       = icons.syntax.Boolean .. " ",
        Array         = icons.syntax.Array .. " ",
        Object        = icons.syntax.Object .. " ",
        Key           = icons.syntax.Key .. " ",
        Null          = icons.syntax.Null .. " ",
        EnumMember    = icons.syntax.EnumMember .. " ",
        Struct        = icons.syntax.Struct .. " ",
        Event         = icons.syntax.Event .. " ",
        Operator      = icons.syntax.Operator .. " ",
        TypeParameter = icons.syntax.TypeParameter .. " ",
      },
      lsp = {
        auto_attach = true,
      },
      click = true,
      highlight = true,
      separator = " " .. icons.ui.DividerRight .. " ",
      -- depth_limit = 7,
    }
  end,
}
