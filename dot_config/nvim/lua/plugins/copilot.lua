local icons = require("icons")
return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		init = function()
			vim.list_extend(require('config.keybinds').which_key_defaults,
				{ { "<Leader>a", group = require('icons').ui.Copilot .. ' Copilot', mode = { "n", "x" } } })
		end,
		opts = {
			panel = {
				enabled = false,
				auto_refresh = false,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<M-CR>"
				},
				layout = {
					position = "bottom", -- | top | left | right
					ratio = 0.4
				},
			},
			suggestion = {
				enabled = false,
				auto_trigger = false,
				debounce = 75,
				keymap = {
					accept = "<M-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			filetypes = {
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			},
			copilot_node_command = 'node', -- Node.js version must be > 18.x
			server_opts_overrides = {
				settings = {
					editor = {
						enableAutoCompletions = true,
					},
					advanced = {
						temperature = 0.2, -- GPT temperature
						top_p = 0.1
					},
					inlineSuggestion = { enable = true },
				}
			},
		}
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		version = "*",
		branch = "canary",
		dependencies = {
			"zbirenbaum/copilot.lua",     -- or github/copilot.vim
			"nvim-lua/plenary.nvim",      -- for curl, log wrapper
			"hrsh7th/nvim-cmp",           -- for completion in the chat window
			'nvim-telescope/telescope.nvim', -- for telescope integration
		},
		cmd = {
			"CopilotChat",
			"CopilotChatOpen",
			"CopilotChatClose",
			"CopilotChatToggle",
			"CopilotChatStop",
			"CopilotChatReset",
			"CopilotChatSave",
			"CopilotChatLoad",
			"CopilotChatDebugInfo",
			"CopilotChatExplain",
			"CopilotChatReview",
			"CopilotChatFix",
			"CopilotChatOptimize",
			"CopilotChatDocs",
			"CopilotChatTests",
			"CopilotChatFixDiagnostic",
			"CopilotChatCommit",
			"CopilotChatCommitStaged",
		},
		keys = {
			{
				"<leader>ac",
				function()
					require("CopilotChat").toggle()
				end,
				desc = icons.ui.Copilot .. " Toggle chat window",
				mode = { "n", "x" }
			},
			-- Show help actions with telescope
			{
				"<leader>ah",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.help_actions())
				end,
				desc = icons.ui.Copilot .. " Help actions",
				mode = { "n", "x" }
			},
			-- Show prompts actions with telescope
			{
				"<leader>ap",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
				end,
				desc = icons.ui.Copilot .. " Prompts",
				mode = { "n", "x" }
			},
			{
				"<leader>ae",
				"<CMD>CopilotChatExplain<CR>",
				mode = { "n", "x" },
				desc = "Explain line/selection",
			},
			{
				"<leader>ad",
				"<CMD>CopilotChatDocs<CR>",
				mode = { "n", "x" },
				desc = "Add documentation for line/selection"
			}
		},
		config = function()
			-- Registers copilot-chat source and enables it for copilot-chat filetype (so copilot chat window)
			require("CopilotChat.integrations.cmp").setup()
			require("CopilotChat").setup {
				debug = false, -- Enable debug logging
				proxy = nil, -- [protocol://]host[:port] Use this proxy
				allow_insecure = false, -- Allow insecure server connections

				system_prompt = require("CopilotChat.prompts").COPILOT_INSTRUCTIONS, -- System prompt to use
				model = 'gpt-4', -- GPT model to use, 'gpt-3.5-turbo' or 'gpt-4'
				temperature = 0.2, -- GPT temperature

				question_header = '## User ', -- Header to use for user questions
				answer_header = '## Copilot ', -- Header to use for AI answers
				error_header = '## Error ', -- Header to use for errors
				separator = '───', -- Separator to use in chat

				show_folds = true, -- Shows folds for sections in chat
				show_help = true, -- Shows help message as virtual lines when waiting for user input
				auto_follow_cursor = true, -- Auto-follow cursor in chat
				auto_insert_mode = false, -- Automatically enter insert mode when opening window and if auto follow cursor is enabled on new prompt
				clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
				highlight_selection = true, -- Highlight selection in the source buffer when in the chat window

				context = 'buffer', -- Default context to use, 'buffers', 'buffer' or none (can be specified manually in prompt via @).
				history_path = vim.fn.stdpath('data') .. '/copilotchat_history', -- Default path to stored history
				callback = nil, -- Callback to use when ask response is received

				-- default selection (visual or line)
				selection = function(source)
					local select = require("CopilotChat.select")
					return select.visual(source) or select.line(source)
				end,

				-- default prompts
				-- system prompts that are always available are COPILOT_INSTRUCTIONS, COPILOT_EXPLAIN,
				-- COPILOT_REVIEW, COPILOT_GENERATE, COPILOT_WORKSPACE, and SHOW_CONTEXT
				prompts = {
					Explain = {
						prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.',
					},
					Review = {
						prompt = '/COPILOT_REVIEW Review the selected code.',
						callback = function(response, source)
							-- see config.lua for implementation
						end,
					},
					Fix = {
						prompt =
						'/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.',
					},
					Optimize = {
						prompt = '/COPILOT_GENERATE Optimize the selected code to improve performance and readablilty.',
					},
					Docs = {
						prompt = '/COPILOT_GENERATE Please add documentation comments for the selection.',
					},
					Tests = {
						prompt = '/COPILOT_GENERATE Please generate tests for my code.',
					},
					FixDiagnostic = {
						prompt = 'Please assist with the following diagnostic issue in file:',
						selection = require("CopilotChat.select").diagnostics,
					},
					Commit = {
						prompt =
						'Write a commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in a code block with language gitcommit.',
						selection = require("CopilotChat.select").gitdiff,
					},
					CommitStaged = {
						prompt =
						'Write a commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in a code block with language gitcommit.',
						selection = function(source)
							return require("CopilotChat.select").gitdiff(source, true)
						end,
					},
				},

				-- default window options
				window = {
					layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
					width = 0.5,       -- fractional width of parent, or absolute width in columns when > 1
					height = 0.5,      -- fractional height of parent, or absolute height in rows when > 1
					-- Options below only apply to floating windows
					relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
					border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
					row = nil,         -- row position of the window, default is centered
					col = nil,         -- column position of the window, default is centered
					title = 'Copilot Chat', -- title of chat window
					footer = nil,      -- footer of chat window
					zindex = 1,        -- determines if window is on top or below other floating windows
				},

				-- default mappings
				mappings = {
					complete = {
						-- detail = 'Use @<Tab> or /<Tab> for options.',
						insert = '',
					},
					close = {
						normal = 'q',
						insert = '<C-c>'
					},
					reset = {
						normal = '<C-l>',
						insert = '<C-l>'
					},
					submit_prompt = {
						normal = '<CR>',
						insert = '<C-CR>'
					},
					accept_diff = {
						normal = '<C-y>',
						insert = '<C-y>'
					},
					yank_diff = {
						normal = 'gy',
					},
					show_diff = {
						normal = 'gd'
					},
					show_system_prompt = {
						normal = 'gp'
					},
					show_user_selection = {
						normal = 'gs'
					},
				},
			}
		end
	}
}
