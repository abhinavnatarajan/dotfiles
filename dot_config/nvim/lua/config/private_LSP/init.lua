local M = {}

-- TODO: automatically install the following packages
M.linters = {
	"cspell",
	"editorconfig-checker",
}
M.formatter_configs = {
	"bibtex-tidy",
	"jupytext",
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
				local client_capabilities = vim.lsp.get_client_by_id(args.data.client_id).server_capabilities

				if not client_capabilities then
					return
				end

				bufmap("n", "gl", vim.diagnostic.open_float, icons.ui.Diagnostics .. " Toggle diagnostics")
				if client_capabilities.inlayHintProvider then
					bufmap({ "n", "i" }, "<F1>",
						function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
						end,
						icons.diagnostics.Hint .. " Toggle inlay hints")
				end
				if client_capabilities.renameProvider then
					bufmap("n", "gR", vim.lsp.buf.rename, icons.syntax.Object .. " Rename symbol")
				end
				if client_capabilities.definitionProvider then
					bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
				end
				if client_capabilities.declarationProvider then
					bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				end
				if client_capabilities.implementationProvider then
					bufmap("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
				end
				if client_capabilities.typeDefinitionProvider then
					bufmap("n", "gT", vim.lsp.buf.type_definition, "Go to type definition")
				end
				if client_capabilities.signatureHelpProvider then
					bufmap("n", "gs", vim.lsp.buf.signature_help, icons.ui.Help .. " Signature help")
					bufmap("i", "<C-s>", vim.lsp.buf.signature_help, icons.ui.Help .. " Signature help")
				end
				if client_capabilities.hoverProvider then
					bufmap("n", "K", vim.lsp.buf.hover, icons.ui.Hover .. " Hover symbol")
					bufmap("i", "<C-S-K>", vim.lsp.buf.hover, icons.ui.Hover .. " Hover symbol")
				end
				if client_capabilities.referencesProvider then
					bufmap("n", "gr",
						function()
							vim.lsp.buf.references(nil, { on_list = vim.g.lsp_reference_handler })
						end,
						"List references")
				end
				if client_capabilities.codeActionProvider then
					bufmap("n", "<F4>", vim.lsp.buf.code_action, icons.ui.Fix .. " Code actions")
					bufmap("x", "<F4>", vim.lsp.buf.code_action, icons.ui.Fix .. " Code actions")
				end
				bufmap("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
				bufmap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
			end,
		}
	)

	-- Default configurations for all servers
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

	-- load Mason
	require("mason")
	-- setup the LSP servers
	require("mason-lspconfig")
	-- setup linters via nvim-lint
	require("lint")
end

return M
