return {
  "williamboman/mason.nvim",
  version = "*",
  config = function()
    require("mason").setup {
      ui = {
        border = "rounded"
      }
    }
  end,
  -- lazy = true,
  cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstallAll", "MasonLog"}
}
