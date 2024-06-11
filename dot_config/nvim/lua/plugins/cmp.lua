return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{
			"saadparwaiz1/cmp_luasnip",
			dependencies = {
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = "make install_jsregexp",
				dependencies = {
					"rafamadriz/friendly-snippets",
					"molleweide/LuaSnip-snippets.nvim"
				},
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip").filetype_extend('quarto', { 'markdown' })
					require("luasnip").filetype_extend('rmarkdown', { 'markdown' })
				end
			},
		},
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-path",
		{
			"petertriho/cmp-git",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {}
		},
		-- {
		-- 	"ExaFunction/codeium.nvim",
		-- 	dependencies = {
		-- 		"nvim-lua/plenary.nvim"
		-- 	},
		-- 	opts = {
		-- 		enable_chat = true
		-- 	}
		-- }
		{
			"zbirenbaum/copilot-cmp",
			cmd = { "Copilot" },
			dependencies = { "zbirenbaum/copilot.lua" },
			opts = {}
		},
	},
	-- this plugin is not versioned
	-- version = "*",
	event = { "InsertEnter", "CmdlineEnter" },
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local icons = require("icons")
		local source_icons = {
			nvim_lsp = icons.ui.Lightbulb,
			luasnip = icons.ui.Code,
			buffer = icons.ui.CodeFile,
			path = icons.ui.Path,
			git = icons.git.Branch,
			cmdline = icons.ui.ChevronRight,
			codeium = icons.ui.Fix,
			copilot = icons.ui.Copilot,
		}
		local lspkindicons = vim.tbl_extend('force', icons.syntax, { Copilot = icons.ui.Copilot, Codeium = icons.ui.Fix })
		local select_opts = { behaviour = cmp.SelectBehavior.Select }
		local confirm_opts = { select = false, behaviour = cmp.ConfirmBehavior.Replace }
		cmp.setup({
			completion = {
				-- autocomplete = false,
			},
			preselect = cmp.PreselectMode.None,
			matching = {
				-- setting the option disallow_prefix_unmatching to true means that
				-- matches where the first few characters do not match
				-- will be discarded
				disallow_prefix_unmatching = false,
				disallow_symbol_nonprefix_matching = false,
				-- partial_matching allows an input like "bode" to be matched to "border"
				disallow_partial_matching = false,
				disallow_fuzzy_matching = false,
				-- if the following option is true, then
				-- the fuzzy matcher will not be used unless prefixes are matched
				disallow_partial_fuzzy_matching = false,
				disallow_fullfuzzy_matching = false,
			},
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			window = {
				completion = {
					border = "single",
				},
				documentation = {
					border = "rounded"
				}
			},
			experimental = {
				-- ghost_text = true,
				ghost_text = {hl_group = 'CmpGhostText'},
			},
			mapping = {
				['<C-u>'] = cmp.mapping.scroll_docs(-4),
				['<C-d>'] = cmp.mapping.scroll_docs(4),
				['<Up>'] = cmp.mapping.select_prev_item(select_opts),
				['<Down>'] = cmp.mapping.select_next_item(select_opts),
				['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
				['<C-n>'] = cmp.mapping.select_next_item(select_opts),
				-- autocomplete key
				['<C-Space>'] = cmp.mapping(function(_)
					if cmp.visible() then
						cmp.abort()
					else
						cmp.complete()
					end
				end, { 'i' }),
				['<CR>'] = cmp.mapping.confirm(confirm_opts), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

				-- Snippet expansion
				['<S-Space>'] = cmp.mapping(function(fallback)
					if luasnip.expand_or_locally_jumpable(1) then
						luasnip.expand_or_jump(1)
					else
						fallback()
					end
				end, { 'i', 's' }),
				-- If the completion menu is visible, move to the next item.
				-- Otherwise check if we can expand or jump in a snippet
				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item(select_opts)
					else
						if pcall(function()
									luasnip.activate_node({ strict = true, select = false })
									return true
								end) and luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end
				end, { 'i', 's' }),
				-- If the completion menu is visible, move to the previous item.
				-- Otherwise check if we can expand or jump in a snippet
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item(select_opts)
					else
						if pcall(function()
									luasnip.activate_node({ strict = true, select = true })
									return true
								end) and luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end
				end, { 'i', 's' }),
			},
			sources = {
				{ name = 'copilot',  group_index = 1 },
				-- { name = 'codeium' },
				{ name = 'nvim_lsp', group_index = 1 },
				-- { name = 'nvim_lsp_signature_help' },
				{ name = 'luasnip',  group_index = 1 }, -- For luasnip users.
				{ name = 'otter',    group_index = 1 },
				{ name = 'git',      group_index = 1 }, -- only active for gitcommit and octo files
				{ name = 'buffer',   group_index = 2 }
			},
			formatting = {
				fields = { 'menu', 'abbr', 'kind' },
				expandable_indicator = true,
				format = function(entry, item)
					item.kind = string.format('%s %s', lspkindicons[item.kind], item.kind)
					item.menu = source_icons[entry.source.name]
					return item
				end,
			},
		})

		-- Set configuration for specific filetype.
		cmp.setup.filetype('tex', {
			formatting = {
				fields = { 'menu', 'abbr', 'kind' },
				expandable_indicator = true,
				format = function(entry, item)
					local kinds = require("config.LSP.servers").get("texlab").CompletionItemKind
					if entry.source.name == 'nvim_lsp' then
						local k = item.kind
						item.kind = kinds[k].icon .. ' ' .. kinds[k].desc
					else
						item.kind = lspkindicons[item.kind] .. ' ' .. item.kind
					end
					item.menu = source_icons[entry.source.name]

					return item
				end
			}
		})

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ '/', '?' }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = { { name = 'buffer' }, },
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(':',
			{
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{
						name = 'cmdline',
						option = {
							ignore_cmds = { 'Man', '!' }
						},
						group_index = 0
					},
					{
						name = 'path',
						option = {
							trailing_slash = true,
							label_trailing_slash = true,
							-- get_cwd = vim.fn.getcwd
						},
						group_index = 1
					}
				}
			})
	end
}
