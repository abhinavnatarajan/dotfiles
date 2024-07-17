local get_range = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local start_row, end_row
	if vim.tbl_contains(
				{ 'v', 'V', 'CTRL-V' },
				vim.fn.mode()
			) then                           -- visual mode
		start_row = vim.fn.line('v')- 1 -- start of visual area
		end_row = vim.fn.line('.')-1
	else -- operate on current line
		start_row = vim.fn.line('.') - 1
		end_row = start_row + 1
	end
	return bufnr, start_row, end_row
end

local explain = function()
	local bufnr, start_row, end_row = get_range()
	vim.ui.input(
		{
			prompt = "(Optional) question: ",
		},
		function(message)
			require('sg.cody.commands').ask_range(
				bufnr,
				start_row,
				end_row,
				message,
				{
					window_type = "split",
					window_opts = {
						width = 0.5
					}
				}
			)
		end
	)
end

local do_task = function()
	local bufnr, start_row, end_row = get_range()
	vim.ui.input(
		{
			prompt = "Task: ",
		},
		function(message)
			require('sg.cody.commands').do_task(
				bufnr,
				start_row,
				end_row,
				message
			)
		end
	)
end

return {
	"sourcegraph/sg.nvim",
	enabled = false,
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	event = "VeryLazy",
	init = function()
		vim.env.SRC_ACCESS_TOKEN = vim.fn.system("gpg --decrypt --quiet sourcegraph_token.txt.gpg")
		require('config.keybinds').which_key_defaults["<Leader>"].a = {
			name = require('icons').ui.Copilot .. ' Cody',
			mode = { "n", "x" },
		}
	end,
	cmds = {
		"CodyChat",
		"CodyAsk",
		"CodyExplain",
		"CodyTask",
		"CodyToggle",
	},
	keys = {
		{
			"<leader>ac",
			"<CMD>CodyToggle<CR>",
			desc = require('icons').ui.Chat .. " Chat",
		},
		{
			"<leader>ae",
			explain,
			desc = require('icons').ui.ChatQuestion .. " Explain current line",
		},
		{
			"<leader>ae",
			explain,
			mode = "x",
			desc = require('icons').ui.ChatQuestion .. " Explain selection"
		},
		{
			"<leader>at",
			do_task,
			desc = require('icons').ui.Edit .. " Perform task on current line",
		},
		{
			"<leader>at",
			do_task,
			desc = require('icons').ui.Edit .. " Perform task on selection",
			mode = "x",
		},
		{
			"<leader>ar",
			"<CMD>CodyRestart<CR>",
			desc = require('icons').ui.Reload .. " Restart Cody",
		}
	},
	opts = {
		enable_cody = true,
		download_binaries = true, -- update binaries from the latest release on Github
		on_attach = function() end, -- override the default on_attach function
		chat = {
			default_model = "anthropic/claude-3-5-sonnet-20240620"
		}
	},
}
