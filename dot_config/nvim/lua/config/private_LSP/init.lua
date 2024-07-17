local M = {}

-- lspconfig names
M.ensure_installed = {
	"basedpyright", -- Python LSP
	"bashls",
	"clangd",
	"cmake",
	"cssls",
	"html",
	"jsonls",
	"julials",
	"ltex",    -- LanguageTool
	"lua_ls",
	"marksman", -- Markdown
	"ruff",
	"rust_analyzer",
	"taplo",
	"texlab",
	"yamlls",
}

function M.setup()
	-- setup diagnostic hints styling
	local icons = require("icons")
	vim.diagnostic.config({
		virtual_text = false,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = icons.diagnostics.BoldError .. " ",
				[vim.diagnostic.severity.WARN] = icons.diagnostics.BoldWarning .. " ",
				[vim.diagnostic.severity.HINT] = icons.diagnostics.BoldHint .. " ",
				[vim.diagnostic.severity.INFO] = icons.diagnostics.BoldInformation .. " ",
			}
		},
		underline = false,
		update_in_insert = false,
		severity_sort = true,
		float = {
			source = true,
			severity_sort = true,
			scope = "line",
			focusable = false,
			close_events = {
				"BufLeave",
				"CursorMoved",
				"InsertEnter",
				"FocusLost",
			},
			border = "rounded",
		},
	})

	-- setup LSP-related keybinds
	require("autocmds").define_autocmd(
		"LspAttach",
		{
			group = "lsp_keybindings",
			callback = function(args)
				local opts = require("config.keybinds").DefaultOpts { buffer = args.buf }
				local bufmap = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
				end
				local server_capabilities = vim.lsp.get_client_by_id(args.data.client_id).server_capabilities

				if not server_capabilities then
					return
				end

				bufmap("n", "gl", vim.diagnostic.open_float, icons.ui.Diagnostics .. " Toggle diagnostics")
				if server_capabilities.inlayHintProvider then
					bufmap({ "n", "i" }, "<F1>",
						function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
						end,
						icons.diagnostics.Hint .. " Toggle inlay hints")
				end
				if server_capabilities.renameProvider then
					bufmap("n", "gR", vim.lsp.buf.rename, icons.syntax.Object .. " Rename symbol")
				end
				if server_capabilities.definitionProvider then
					bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
				end
				if server_capabilities.declarationProvider then
					bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				end
				if server_capabilities.implementationProvider then
					bufmap("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
				end
				if server_capabilities.typeDefinitionProvider then
					bufmap("n", "gT", vim.lsp.buf.type_definition, "Go to type definition")
				end
				if server_capabilities.signatureHelpProvider then
					bufmap("n", "gs", vim.lsp.buf.signature_help, icons.ui.Help .. " Signature help")
					bufmap("i", "<C-s>", vim.lsp.buf.signature_help, icons.ui.Help .. " Signature help")
				end
				if server_capabilities.hoverProvider then
					bufmap("n", "K", vim.lsp.buf.hover, icons.ui.Hover .. " Hover symbol")
					bufmap("i", "<C-S-K>", vim.lsp.buf.hover, icons.ui.Hover .. " Hover symbol")
				end
				if server_capabilities.referencesProvider then
					bufmap("n", "gr",
						function()
							vim.lsp.buf.references(nil, { on_list = vim.g.lsp_reference_handler })
						end,
						"List references")
				end
				if server_capabilities.codeActionProvider then
					bufmap("n", "<F4>", vim.lsp.buf.code_action, icons.ui.Fix .. " Code actions")
					bufmap("x", "<F4>", vim.lsp.buf.code_action, icons.ui.Fix .. " Code actions")
				end
				bufmap("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
				bufmap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
			end,
		}
	)

	-- Default configurations for all servers
	-- Note: order of priority of server configurations is as follows
	-- user configuration > lspconfig server_configurations > lspconfig.util.default_config
	-- lspconfig.__index does lspconfig['server'] = lspconfig.server_configurations['server']
	-- lspconfig.__newindex is called during the above assignment
	-- which merges lspconfig.server_configurations['server'] with lspconfig.util.default_config
	local lspconfig = require("lspconfig")
	local lsp_defaults = lspconfig.util.default_config
	-- style LSP floating hints
	lsp_defaults.handlers = vim.tbl_deep_extend("force", lsp_defaults.handlers, {
		["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			focusable = true,
			border = "rounded",
		}),
		["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			focusable = true,
			border = "rounded",
		}),
	})
	require("lspconfig.ui.windows").default_options.border = "rounded"

	-- if cmp_nvim_lsp has been loaded then we will add autocomplete capabilities to the lsp servers by default
	if package.loaded["cmp_nvim_lsp"] then
		lsp_defaults.capabilities =
				vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
	end

	lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)

	-- server setup functions
	local server_handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup {}
		end
	}
	for _, server_name in ipairs(M.ensure_installed) do
		local ok, server = pcall(require, "config.LSP." .. server_name)
		if ok then
			if server.handler then
				server_handlers[server_name] = server.handler
			elseif server.config then
				server_handlers[server_name] = function()
					require("lspconfig")[server_name].setup(server.config)
				end
			end
		end
	end

	-- setup the LSP servers
	require("mason-lspconfig").setup({ handlers = server_handlers })
end

return M
