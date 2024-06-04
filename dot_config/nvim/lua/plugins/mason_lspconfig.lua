return {
  "williamboman/mason-lspconfig.nvim",
  version = "*",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
  },
  cmd = {"LspInstall", "LspUninstall"},
  config = false
}
