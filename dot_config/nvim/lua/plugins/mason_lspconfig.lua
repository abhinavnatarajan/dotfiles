return {
  "williamboman/mason-lspconfig.nvim",
  version = "*",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
  },
  -- lazy = true,
  cmd = {"LspInstall", "LspUninstall"},
  config  = function() end -- configure separately
}
