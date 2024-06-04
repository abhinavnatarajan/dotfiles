return {
	"windwp/nvim-autopairs",
	-- nvim-autopairs is not versioned
	-- version = "*",
	event = "InsertEnter",
	config = function()
		local npairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")
		npairs.setup({ map_cr = true })

		-- Rules for latex delimiters and some special cases
		npairs.add_rules({
			Rule("$", "$", { "tex", "latex" }):with_move(cond.done()),
			Rule("\\[", "\\]", { "tex", "latex" }):with_move(cond.done()),
			Rule("\\{", "\\}", { "tex", "latex" }),
			Rule("", "\\", { "tex", "latex" })
				:use_key("\\")
				:with_pair(cond.none())
				:with_del(cond.none())
				:with_move(function(opts)
					local check_chars = opts.line:sub(opts.col, opts.col + 1)
					return check_chars == "\\}" or check_chars == "\\]"
				end),
		})
	end,
}
