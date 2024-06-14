return {
	"luukvbaal/statuscol.nvim",
	dependencies = { "lewis6991/gitsigns.nvim" },
	branch = "0.10",
	-- this plugin is not versioned
	event = "BufWinEnter",
	config = function()
		local builtin = require("statuscol.builtin")
		local bt_ignore = {}
		for name, _ in pairs(require("utils.windows").exclude_buftypes) do
			table.insert(bt_ignore, name)
		end
		require("statuscol").setup({
			setopt = true, -- Whether to set the 'statuscolumn' option, may be set to false for those who
			-- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
			-- Although I recommend just using the segments field below to build your
			-- statuscolumn to benefit from the performance optimizations in this plugin.
			-- builtin.lnumfunc number string options
			thousands = false, -- or line number thousands separator string ("." / ",")
			relculright = false, -- whether to right-align the cursor line number with 'relativenumber' set
			-- Builtin 'statuscolumn' options
			ft_ignore = nil, -- lua table with filetypes for which 'statuscolumn' will be unset
			bt_ignore = bt_ignore, -- lua table with 'buftype' values for which 'statuscolumn' will be unset

			segments = {
				-- {
				-- 	text = { "%C" }, -- table of strings or functions returning a string
				-- 	click = "v:lua.ScFa", -- %@ click function label, applies to each text element
				-- 	hl = "FoldColumn", -- %# highlight group label, applies to each text element
				-- 	condition = { true }, -- table of booleans or functions returning a boolean
				-- 	sign = { -- table of fields that configure a sign segment
				-- 		-- at least one of "name", "text", and "namespace" is required
				-- 		-- legacy signs are matched against the defined sign name e.g. "DiagnosticSignError"
				-- 		-- extmark signs can be matched against either the namespace or the sign text itself
				-- 		name = { ".*" }, -- table of lua patterns to match the legacy sign name against
				-- 		text = { ".*" }, -- table of lua patterns to match the extmark sign text against
				-- 		namespace = { ".*" }, -- table of lua patterns to match the extmark sign namespace against
				-- 		-- below values list the default when omitted:
				-- 		maxwidth = 1, -- maximum number of signs that will be displayed in this segment
				-- 		colwidth = 2, -- number of display cells per sign in this segment
				-- 		auto = false, -- when true, the segment will not be drawn if no signs matching
				-- 		-- the pattern are currently placed in the buffer.
				-- 		wrap = false, -- when true, signs in this segment will also be drawn on the
				-- 		-- virtual or wrapped part of a line (when v:virtnum != 0).
				-- 		fillchar = " ", -- character used to fill a segment with less signs than maxwidth
				-- 		fillcharhl = nil, -- highlight group used for fillchar (SignColumn/CursorLineSign if omitted)
				-- 		foldclosed = false, -- when true, show signs from lines in a closed fold on the first line
				-- 	},
				-- },
				{
					-- fold symbols
					text = { builtin.foldfunc },
					click = "v:lua.ScFa",
				},
				{
					-- diagnostic symbols
					sign = {
						namespace = { "diagnostic" },
						maxwidth = 1,
						auto = false,
					},
					click = "v:lua.ScSa",
				},
				{
					-- debug breakpoint column
					sign = {
						name = { "Dap.*" },
						maxwidth = 2,
						colwidth = 2,
						auto = true,
					},
					click = "v:lua.ScSa",
				},
				{
					-- line numbers
					text = { builtin.lnumfunc },
					click = "v:lua.ScLa",
				},
				{
					-- gitsigns column
					sign = {
						namespace = { "gitsign" },
						maxwidth = 1,
						colwidth = 1,
						auto = false,
						fillcharhl = "GitSignsCol",
						fillchar = "┃",
					},
					click = "v:lua.ScSa",
				},
			},
			clickmod = "c", -- modifier used for certain actions in the builtin clickhandlers:
			-- "a" for Alt, "c" for Ctrl and "m" for Meta.
			clickhandlers = { -- builtin click handlers
				Lnum = builtin.lnum_click,
				FoldClose = builtin.foldclose_click,
				FoldOpen = builtin.foldopen_click,
				FoldOther = builtin.foldother_click,
				DapBreakpointRejected = builtin.toggle_breakpoint,
				DapBreakpoint = builtin.toggle_breakpoint,
				DapBreakpointCondition = builtin.toggle_breakpoint,
				DiagnosticSignError = builtin.diagnostic_click,
				DiagnosticSignHint = builtin.diagnostic_click,
				DiagnosticSignInfo = builtin.diagnostic_click,
				DiagnosticSignWarn = builtin.diagnostic_click,
				GitSignsTopdelete = builtin.gitsigns_click,
				GitSignsUntracked = builtin.gitsigns_click,
				GitSignsAdd = builtin.gitsigns_click,
				GitSignsChange = builtin.gitsigns_click,
				GitSignsChangedelete = builtin.gitsigns_click,
				GitSignsDelete = builtin.gitsigns_click,
				gitsigns_extmark_signs_ = builtin.gitsigns_click,
			},
		})
	end,
}
