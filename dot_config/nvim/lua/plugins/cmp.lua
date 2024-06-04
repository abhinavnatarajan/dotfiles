return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"jmbuhr/otter.nvim",
		"micangl/cmp-vimtex",
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = "make install_jsregexp",
			dependencies = {
				"rafamadriz/friendly-snippets",
				"molleweide/LuaSnip-snippets.nvim"
			},
			config = function() require("luasnip.loaders.from_vscode").lazy_load() end
		},
		"saadparwaiz1/cmp_luasnip",
		"petertriho/cmp-git",
	},
	-- this plugin is not versioned
	-- version = "*",
	event = { "InsertEnter", "CmdlineEnter" },
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local icons = require("icons")
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
					-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			},
			window = {
				completion = {
					border = "rounded",
				},
				documentation = {
					border = "rounded"
				}
			},
			experimental = {
				ghost_text = { hl_group = 'CmpGhostText' },
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
			sources = cmp.config.sources(
				{
					{ name = 'nvim_lsp' },
					-- { name = 'nvim_lsp_signature_help' },
					{ name = 'luasnip' }, -- For luasnip users.
					{ name = 'otter' },
				},
				-- by grouping sources we don't see the second group when the first group is available
				{
					{ name = 'buffer' }
				}
			),
			formatting = {
				fields = { 'menu', 'abbr', 'kind' },
				format = function(entry, item)
					local menu_icon = {
						nvim_lsp = icons.ui.Lightbulb,
						luasnip = icons.ui.Code,
						buffer = icons.ui.CodeFile,
						path = icons.ui.Path,
						cmdline = icons.ui.ChevronRight,
					}
					item.kind = string.format('%s %s', icons.syntax[item.kind], item.kind)
					item.menu = menu_icon[entry.source.name]
					return item
				end,
			},
		})

		-- Set configuration for specific filetype.
		cmp.setup.filetype('gitcommit', {
			sources = cmp.config.sources(
				{
					{ name = 'git' },
				}, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
				{
					{ name = 'buffer' },
				}
			)
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
				sources = cmp.config.sources(
					{
						{
							name = 'cmdline',
							option = {
								ignore_cmds = { 'Man', '!' }
							},
						},
					},
					{
						{
							name = 'path',
							option = {
								trailing_slash = true,
								label_trailing_slash = true,
								-- get_cwd = vim.fn.getcwd
							},
						},
					}
				)
			}
		)
		require("cmp_git").setup()
	end
}
