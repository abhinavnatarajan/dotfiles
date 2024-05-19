require('nvim-surround').buffer_setup({
	-- Configuration here, or leave empty to use defaults
	surrounds = {
		["e"] = {
			add = function()
				local env = require("nvim-surround.config").get_input "Environment: "
				return { { "\\begin{" .. env .. "}" }, { "\\end{" .. env .. "}" } }
			end,
		},
		["c"] = {
			add = function()
				local cmd = require("nvim-surround.config").get_input "Command: "
				return { { "\\" .. cmd .. "{" }, { "}" } }
			end,
		},
	}
})

-- Labelled vimtex keybinds
local vimtex_keybind = function()
	local wk = require("which-key")
	local DefaultOpts = require("utils").prototype {
		buffer = 0,   -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
		expr = false,
	}
	local mappings = {
		["<leader>"] = {
			["l"] = {
				name = "Vimtex",
				["i"] = { "<plug>(vimtex-info-full)", "Info" },
				["I"] = { "<plug>(vimtex-info-full)", "Info (full)" },
				["t"] = { "<plug>(vimtex-toc-toggle)", "Toggle table of contents" },
				["q"] = { "<plug>(vimtex-log)", "Log" },
				["v"] = { "<plug>(vimtex-view)", "View document" },
				["r"] = { "<plug>(vimtex-reverse-search)", "Reverse search" },
				["l"] = { "<plug>(vimtex-compile)", "Compile" },
				["L"] = { "<plug>(vimtex-compile-selected)", "Compile selected", { mode = {"n", "x"} } },
				["k"] = { "<plug>(vimtex-stop)", "Stop" },
				["K"] = { "<plug>(vimtex-stop-all)", "Stop (all)" },
				["e"] = { "<plug>(vimtex-errors)", "Errors" },
				["o"] = { "<plug>(vimtex-compile-output)", "Compiler output" },
				["g"] = { "<plug>(vimtex-status)", "Status" },
				["G"] = { "<plug>(vimtex-status-all)", "Status (all)" },
				["c"] = { "<plug>(vimtex-clean)", "Clean" },
				["C"] = { "<plug>(vimtex-clean-full)", "Clean (full)" },
				["m"] = { "<plug>(vimtex-imaps-list)", "List insert mode keymaps" },
				["x"] = { "<plug>(vimtex-reload)", "Reload Vimtex" },
				["X"] = { "<plug>(vimtex-reload-state)", "Reload Vimtex state" },
				["s"] = { "<plug>(vimtex-toggle-main)", "Toggle main file" },
				["a"] = { "<plug>(vimtex-context-menu)", "Context menu" },
			}
		}
	}
	wk.register(mappings, DefaultOpts)
end

vimtex_keybind()
