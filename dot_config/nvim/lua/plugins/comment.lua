return {
	'numToStr/Comment.nvim',
	opts = {
		---Add a space b/w comment and the line
		padding = true,
		---Whether the cursor should stay at its position
		sticky = true,
		---Lines to be ignored while (un)comment
		ignore = nil,
		---LHS of toggle mappings in NORMAL mode
		toggler = {
			---Line-comment toggle keymap
			line = 'gcc',
			---Block-comment toggle keymap
			block = 'gbc',
		},
		---LHS of operator-pending mappings in NORMAL and VISUAL mode
		opleader = {
			---Line-comment keymap
			line = 'gc',
			---Block-comment keymap
			block = 'gb',
		},
		---LHS of extra mappings
		extra = {
			---Add comment on the line above
			above = 'gcO',
			---Add comment on the line below
			below = 'gco',
			---Add comment at the end of line
			eol = 'gcA',
		},
		---Enable keybindings
		---NOTE: If given `false` then the plugin won't create any mappings
		mappings = {
			---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
			basic = true,
			---Extra mapping; `gco`, `gcO`, `gcA`
			extra = false,
		},
		---Function to call before (un)comment
		pre_hook = function()
			local c = require("Comment")
			if c.temp_pos ~= nil then return end
			c.temp_pos = vim.api.nvim_win_get_cursor(0)
		end,
		---Function to call after (un)comment
		post_hook = function(ctx)
			local c = require("Comment")
			local U = require("Comment.utils")
			local cfg = require("Comment.config"):get()
			local left, _ = U.parse_cstr(cfg, ctx)
			local offset = #left + 1
			if ctx.cmode == U.cmode.uncomment then
				offset = -offset
			end
			local pos = c.temp_pos
			local row, col = pos[1], pos[2]
			col = math.max(0, col + offset)
			vim.api.nvim_win_set_cursor(0, { row, col })
			c.temp_pos = nil
		end,
	},
	keys = {
		{ "<C-/>", "<Plug>(comment_toggle_linewise_current)",        desc = require("icons").ui.Comment .. " Toggle line comment",  mode = "n", noremap = false },
		{ "<C-/>", "<Plug>(comment_toggle_linewise_visual)gv",       desc = require("icons").ui.Comment .. " Toggle line comment",  mode = "x", noremap = false },
		{ "<C-/>", "<Esc><Plug>(comment_toggle_linewise_current)a",  desc = require("icons").ui.Comment .. " Toggle line comment",  mode = "i", noremap = false },
		{ "<A-/>", "<Plug>(comment_toggle_blockwise_current)",       desc = require("icons").ui.Comment .. " Toggle block comment", mode = "n", noremap = false },
		{ "<A-/>", "<Plug>(comment_toggle_blockwise_visual)gv",      desc = require("icons").ui.Comment .. " Toggle block comment", mode = "x", noremap = false },
		{ "<A-/>", "<Esc><Plug>(comment_toggle_blockwise_current)a", desc = require("icons").ui.Comment .. " Toggle block comment", mode = "i", noremap = false },
		{
			"gcA",
			function()
				local cfg = require("Comment.config"):get()
				local temp_cfg = vim.deepcopy(cfg)
				temp_cfg.pre_hook = nil
				temp_cfg.post_hook = nil
				local ctype = require("Comment.utils").ctype.linewise
				require("Comment.extra").insert_eol(ctype, temp_cfg)
			end,
			desc = require("icons").ui.Comment .. " Comment at EOL",
			mode = "n",
			noremap = false
		},
		{
			"gco",
			function()
				local cfg = require("Comment.config"):get()
				local temp_cfg = vim.deepcopy(cfg)
				temp_cfg.pre_hook = nil
				temp_cfg.post_hook = nil
				local ctype = require("Comment.utils").ctype.linewise
				require("Comment.extra").insert_below(ctype, temp_cfg)
			end,
			desc = require("icons").ui.Comment .. " Comment below",
			mode = "n",
			noremap = false
		},
		{
			"gcO",
			function()
				local cfg = require("Comment.config"):get()
				local temp_cfg = vim.deepcopy(cfg)
				temp_cfg.pre_hook = nil
				temp_cfg.post_hook = nil
				local ctype = require("Comment.utils").ctype.linewise
				require("Comment.extra").insert_above(ctype, temp_cfg)
			end,
			desc = require("icons").ui.Comment .. " Comment above",
			mode = "n",
			noremap = false
		},
	}
}
