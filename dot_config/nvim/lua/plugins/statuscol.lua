return {
	"luukvbaal/statuscol.nvim",
	dependencies = { "lewis6991/gitsigns.nvim" },
	event = "User FileOpened",
	config = function()
		local builtin = require("statuscol.builtin")
		local bt_ignore = {}
		for name, _ in pairs(require('utils.windows').exclude_buftypes) do
			table.insert(bt_ignore, name)
		end
		require("statuscol").setup {
			setopt = true,         -- Whether to set the 'statuscolumn' option, may be set to false for those who
			-- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
			-- Although I recommend just using the segments field below to build your
			-- statuscolumn to benefit from the performance optimizations in this plugin.
			-- builtin.lnumfunc number string options
			thousands = false,     -- or line number thousands separator string ("." / ",")
			relculright = false,   -- whether to right-align the cursor line number with 'relativenumber' set
			-- Builtin 'statuscolumn' options
			ft_ignore = nil,       -- lua table with filetypes for which 'statuscolumn' will be unset
			bt_ignore = bt_ignore,       -- lua table with 'buftype' values for which 'statuscolumn' will be unset

			segments = {
				{
					text = { builtin.foldfunc },
					click = "v:lua.ScFa"
				},
				{
					sign = {
						name = { "Diagnostic" },
						maxwidth = 1,
						auto = false,
					},
					click = "v:lua.ScSa",
				},
				{
					text = { builtin.lnumfunc, },
					click = "v:lua.ScLa",
				},
				{
					sign = {
						name = { "Git" },
						maxwidth = 1,
						colwidth = 1,
						auto = true,
						fillcharhl = "GitSignsCol",
						fillchar = "┃",
					},
					click = "v:lua.ScSa",
				},
				{
					sign = {
						name = { ".*" },
						maxwidth = 1,
						colwidth = 1,
						auto = true,
					},
					click = "v:lua.ScSa",
				},

			},
			clickmod = "c",         -- modifier used for certain actions in the builtin clickhandlers:
			-- "a" for Alt, "c" for Ctrl and "m" for Meta.
			clickhandlers = {       -- builtin click handlers
				Lnum                    = builtin.lnum_click,
				FoldClose               = builtin.foldclose_click,
				FoldOpen                = builtin.foldopen_click,
				FoldOther               = builtin.foldother_click,
				DapBreakpointRejected   = builtin.toggle_breakpoint,
				DapBreakpoint           = builtin.toggle_breakpoint,
				DapBreakpointCondition  = builtin.toggle_breakpoint,
				DiagnosticSignError     = builtin.diagnostic_click,
				DiagnosticSignHint      = builtin.diagnostic_click,
				DiagnosticSignInfo      = builtin.diagnostic_click,
				DiagnosticSignWarn      = builtin.diagnostic_click,
				GitSignsTopdelete       = builtin.gitsigns_click,
				GitSignsUntracked       = builtin.gitsigns_click,
				GitSignsAdd             = builtin.gitsigns_click,
				GitSignsChange          = builtin.gitsigns_click,
				GitSignsChangedelete    = builtin.gitsigns_click,
				GitSignsDelete          = builtin.gitsigns_click,
				gitsigns_extmark_signs_ = builtin.gitsigns_click,
			},
		}
	end,
}
