return {
	"kylechui/nvim-surround", --delimiter manipulation
	version = "*",           -- Use for stability; omit to use `main` branch for the latest features
	event = "User FileOpened",
	keys = function()
		return {
			{ "ys",    "<Plug>(nvim-surround-normal)",          desc = require("icons").ui.DelimiterPair .. " Surround" },
			{ "yss",   "<Plug>(nvim-surround-normal-cur)",      desc = require("icons").ui.DelimiterPair .. " Surround line" },
			{ "yS",    "<Plug>(nvim-surround-normal-line)",     desc = require("icons").ui.DelimiterPair .. " Surround on new lines" },
			{ "ySS",   "<Plug>(nvim-surround-normal-cur-line)", desc = require("icons").ui.DelimiterPair .. " Surround line on new lines" },
			{ "ds",    "<Plug>(nvim-surround-delete)",          desc = require("icons").ui.DelimiterPair .. " Delete delimiter" },
			{ "cs",    "<Plug>(nvim-surround-change)",          desc = require("icons").ui.DelimiterPair .. " Change delimiter" },
			-- visual mode mappings
			{ "<A-s>", "<Plug>(nvim-surround-visual)",          desc = require("icons").ui.DelimiterPair .. " Surround",                  mode = { "x" } },
			{ "<A-S>", "<Plug>(nvim-surround-visual-line)",     desc = require("icons").ui.DelimiterPair .. " Surround on new lines",     mode = { "x" } },
			-- insert mode mappings
			-- { "<A-S>", "<Plug>(nvim-surround-insert-line)", mode = { "i" }, desc = "Surround on new lines" },
			-- { "<A-s>", "<Plug>(nvim-surround-insert)", mode = { "i" }, desc = "Surround" },
		}
	end,

	opts = {
		-- Configuration here, or leave empty to use defaults
		keymaps = {
			normal = false,
			normal_line = false,
			normal_cur = false,
			normal_cur_line = false,
			insert = false,
			insert_line = false,
			visual = false,
			visual_line = false,
		},
	},
}
