local ft_surrounds = {
	{
		ft_pattern = "tex",
		group = "tex",
		opts = {
			surrounds = {
				["e"] = {
					add = function()
						local env = require("nvim-surround.config").get_input("Environment: ")
						if env then
							return { { "\\begin{" .. env .. "}" }, { "\\end{" .. env .. "}" } }
						else
							return { { "" }, { "" } }
						end
					end,
				},
				["c"] = {
					add = function()
						local cmd = require("nvim-surround.config").get_input("Command: ")
						if cmd then
							return { { "\\" .. cmd .. "{" }, { "}" } }
						else
							return { { "" }, { "" } }
						end
					end,
				},
			},
		}
	},
	{
		ft_pattern = { "markdown", "quarto", "rmd" },
		group = "markdown",
		opts = {
			aliases = {
				['b'] = '**',
				['e'] = '*',
				['c'] = '`',
				['C'] = '```',
			}
		}
	}
}
return {
	"kylechui/nvim-surround", --delimiter manipulation
	version = "*",           -- Use for stability; omit to use `main` branch for the latest features
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
	config = function(_, opts)
		require("nvim-surround").setup(opts)
		for _, val in ipairs(ft_surrounds) do
			-- check if the current file is one of the filetypes for which we have custom surrounds
			-- if it is, setup the surrounds
			-- otherwise, setup an autocmd to setup the surrounds when the filetype is set
			if val.ft_pattern == vim.bo.filetype or (type(val.ft_pattern) == "table" and vim.tbl_contains(val.ft_pattern, vim.bo.filetype)) then
				require("nvim-surround").buffer_setup(val.opts)
			else
				require("autocmds").define_autocmd(
					"FileType",
					{
						pattern = val.ft_pattern,
						group = "nvim_surround_" .. val.group,
						desc = "Setup surrounds for " .. val.group .. " files",
						callback = function()
							require("nvim-surround").buffer_setup(val.opts)
						end
					}
				)
			end
		end
	end
}
