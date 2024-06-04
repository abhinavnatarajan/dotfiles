local M = {}

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
			source = "if_many",
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

	-- Plugins and config directory LSP hints
	require("neodev")

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

	-- load the lsp servers
	require("mason")
	local mason_registry = require("mason-registry")
	local packages = {
		LSP = {
			lua_ls = {
				settings = {
					Lua = {
						workspace = {
							checkThirdParty = false,
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},
			julials = {
				-- following code snippet is from https://github.com/fredrikekre/.dotfiles/blob/master/.julia/environments/nvim-lspconfig/Makefile
				on_new_config = function(new_config, _)
					local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
					if require("lspconfig").util.path.is_file(julia) then
						new_config.cmd[1] = julia
					end
				end,
			},
			bashls = {},
			-- Python LSP
			pyright = {},
			-- Markdown
			marksman = {},
			html = {},
			texlab = {
				settings = {
					texlab = {
						experimental = {
							labelReferenceCommands = { "fullref" }, -- custom command that I defined in a paper
							mathEnvironments = { "diagram" },
						},
					},
				},
			},
			matlab_ls = {},
			jsonls = {},
			yamlls = {},
			clangd = {},
			cmake = {},
			taplo = {},
			cssls = {},
			rust_analyzer = {},
			-- LanguageTool
			ltex = {
				on_attach = function()
					require("ltex_extra").setup()
				end,
				flags = {
					debounce_text_changes = 500,
				},
				settings = {
					ltex = {
						enabled = {
							"latex",
							"tex",
							"markdown",
							"bibtex",
							"restructuredtext",
							"plaintext",
							"git-commit",
							-- "html",
						},
						language = "en-GB",
						checkFrequency = "save",
						-- configurationTarget = {
						-- 	dictionary = "workspaceFolderExternalFile",
						-- 	hiddenFalsePositives = "workspaceFolderExternalFile",
						-- 	disabledRules = "workspaceFolderExternalFile"
						-- },
						["ltex-ls"] = { logLevel = "config" },
						latex = {
							commands = {
								["\\label"] = "ignore",
								["\\fullref"] = "dummy",
								["\\cref"] = "dummy",
								["\\nameref"] = "dummy",
							},
							environments = {
								["diagram"] = "ignore",
							},
						},
					},
				},
			},
		},

		debuggers = {
			"debugpy",
		},

		linters = {},

		formatters = {
			"bibtex-tidy",
			"jupytext",
		},
	}

	local function ensure_installed()
		for name, _ in pairs(packages.LSP) do
			if (not mason_registry.is_installed(name)) and mason_registry.has_package(name) then
				vim.cmd("MasonInstall " .. name)
			end
		end
		local categories = { "debuggers", "linters", "formatters" }
		for _, category in ipairs(categories) do
			for _, name in ipairs(packages[category]) do
				if (not mason_registry.is_installed(name)) and mason_registry.has_package(name) then
					vim.cmd("MasonInstall " .. name)
				end
			end
		end
	end
	mason_registry.refresh(ensure_installed)

	-- mason-lspconfig MUST be loaded after mason
	require("mason-lspconfig").setup({})
	for name, opts in pairs(packages.LSP) do
		lspconfig[name].setup(opts)
	end
end

return M
