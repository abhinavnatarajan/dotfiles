local M = {}

function M.setup()
  -- setup diagnostic hints styling
  local icons = require("icons")
  local signs = {
    Error = icons.diagnostics.BoldError .. " ",
    Warn = icons.diagnostics.BoldWarning .. " ",
    Hint = icons.diagnostics.BoldHint .. " ",
    Info = icons.diagnostics.BoldInformation .. " ",
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = false,
    update_in_insert = false,
    severity_sort = false,
    float = {
      source = 'always',
      prefix = ' ',
      scope = 'line',
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
    },
  })

  -- Plugins and config directory LSP hints
  require("neodev")

  -- Default configurations for all servers
  local lspconfig = require("lspconfig")
  local lsp_defaults = lspconfig.util.default_config
  -- style LSP floating hints
  lsp_defaults.handlers = vim.tbl_deep_extend(
    "force",
    lsp_defaults.handlers,
    {
      ["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
          focusable = false,
          border = "rounded",
        }
      ),
      ["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {
          focusable = false,
          border = "rounded",
        }
      )
    }
  )
  require("lspconfig.ui.windows").default_options.border = "rounded"

  -- if cmp_nvim_lsp has been loaded then we will add autocomplete capabilities to the lsp servers by default
  if package.loaded["cmp_nvim_lsp"] then
    lsp_defaults.capabilities = vim.tbl_deep_extend(
      'force',
      lsp_defaults.capabilities,
      require('cmp_nvim_lsp').default_capabilities()
    )
  end

  -- load the lsp servers
  -- mason-lspconfig MUST be loaded after mason
  require("mason")
  require("mason-lspconfig").setup {
    ensure_installed = {
      "lua_ls",
      "pyright",
      "jsonls",
      "yamlls",
      "julials",
      "bashls",
      "marksman",
      "html",
      "clangd",
      "cmake",
      "cssls",
    }
  }


  -- LSP Servers Setup
  lspconfig.lua_ls.setup{
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        completion = {
          callSnippet = "Replace"
        }
      }
    },
  }
  lspconfig.pyright.setup{}
  lspconfig.jsonls.setup{}
  lspconfig.yamlls.setup{}
  lspconfig.bashls.setup{}
  lspconfig.julials.setup{}
  lspconfig.marksman.setup{}
  lspconfig.html.setup{}
  lspconfig.clangd.setup{}
  lspconfig.cmake.setup{}
  lspconfig.cssls.setup{}
  lspconfig.rust_analyzer.setup{}

  -- Formatters
  -- lspconfig.autoflake.setup{}
  -- lspconfig.autopep8.setup{}
  -- lspconfig["clang-format"].setup{}
end


return M
