local M = {}

M.DefaultOpts = require("utils").prototype({
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	remap = false, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
	expr = false,
})
local DefaultOpts = M.DefaultOpts
local icons = require("icons")

M.keymaps = {
	{ "n",          "<leader>W",  "<CMD>wa!<CR>",                                                  DefaultOpts { desc = icons.ui.SaveAll .. " Save all" } },
	{ "n",          "<leader>q",  "<CMD>confirm qa<CR>",                                           DefaultOpts { desc = icons.ui.BoldClose .. " Quit with confirmation" } },
	{ "n",          "<leader>Q",  "<CMD>qa!<CR>",                                                  DefaultOpts { desc = icons.ui.BoldClose .. " Quit" } },
	{ "n",          "<leader>%",  "<CMD>cd %:p:h<CR>",                                             DefaultOpts { desc = icons.ui.FolderActive .. " Set working directory from active buffer" } },
	{ "n",          "<leader>-",  "<CMD>cd ..<CR>",                                                DefaultOpts { desc = icons.ui.FolderUp .. " Go up one directory" } },
	{ "n",          "<leader>C",  "q:",                                                            DefaultOpts { desc = icons.ui.Terminal .. " Command history" } },
	{ "n",          "<leader>si", function() require("utils.editing").select_indent(false) end,    DefaultOpts { desc = icons.ui.Indent .. " Set indentation" } },
	{ "n",          "<leader>fi", function() require("utils.editing").select_indent(true) end,     DefaultOpts { desc = icons.ui.Indent .. " Set buffer indentation" } },
	{ "n",          "<leader>fn", function() require("utils.windows").edit_new_file_handler() end, DefaultOpts { desc = icons.ui.NewFile .. " New file" } },
	{ "n",          "<leader>fm", function() require("utils.editing").choose_file_newline() end,   DefaultOpts { desc = icons.ui.ReturnCharacter .. " Set newline format" } },
	{ "n",          "<leader>Pm", function() require("lazy").home() end,                           DefaultOpts { desc = icons.ui.Configure .. " Manage plugins" } },

	--[[ Tab management ]]
	{ { "n", "i" }, "<A-t>",      "<CMD>tabn<CR>",                                                 DefaultOpts { desc = icons.ui.ArrowRight .. ' Next tab' } },
	{ { "n", "i" }, "<A-T>",      "<CMD>tabN<CR>",                                                 DefaultOpts { desc = icons.ui.ArrowLeft .. ' Previous tab' } },
	{ "n",          "<leader>te", "<CMD>tab split<CR>",                                            DefaultOpts { desc = icons.ui.Edit .. " Edit in new tab" } },
	{ "n",          "<leader>to", "<CMD>tabonly<CR>",                                              DefaultOpts { desc = "Close all other tabs" } },
	{ "n",          "<leader>tn", "<CMD>tab split<CR>",                                            DefaultOpts { desc = icons.ui.OpenInNew .. " New file in new tab" } },
	{ "n",          "<leader>tc", "<CMD>tabclose<CR>",                                             DefaultOpts { desc = "Close current tab" } },
	{ "n",          "<leader>tH", "<CMD>silent! tabmove -1<CR>",                                   DefaultOpts { desc = icons.ui.BoldArrowLeft .. " Move tab to the left" } },
	{ "n",          "<leader>tL", "<CMD>silent! tabmove +1<CR>",                                   DefaultOpts { desc = icons.ui.BoldArrowRight .. " Move tab to the right" } },
	{ "n",          "<leader>tf", "<CMD>tabs<CR>",                                                 DefaultOpts { desc = icons.ui.FindTab .. " Find tabs" } },
	{
		"n", "<leader>tj",
		function()
			vim.ui.input({ prompt = "Go to tab:" }, function(input)
				vim.cmd("silent! tabnext" .. input)
			end)
		end,
		{ desc = "Jump to tab" },
	},
	{ "t", "<Esc>",     [[<C-\><C-n>]],                                                       DefaultOpts { desc = "Normal mode" } },
	{ "n", "gx",        [[:exe 'silent !open ' . shellescape(expand('<cfile>', 1))<CR>]],     DefaultOpts { desc = icons.ui.Window .. " Open in external program" } },

	--[[ Navigation and resizing ]]
	-- Resize with arrows
	{ "n", "<C-Up>",    "<CMD>resize +2<CR>",                                                 DefaultOpts { desc = icons.ui.ExpandVertical .. " Shrink window vertically" } },
	{ "n", "<C-Down>",  "<CMD>resize -2<CR>",                                                 DefaultOpts { desc = icons.ui.ExpandVertical .. " Expand window vertically" } },
	{ "n", "<C-Left>",  "<CMD>vertical resize -2<CR>",                                        DefaultOpts { desc = icons.ui.ExpandHorizontal .. " Shrink window horizontally" } },
	{ "n", "<C-Right>", "<CMD>vertical resize +2<CR>",                                        DefaultOpts { desc = icons.ui.ExpandHorizontal .. " Expand window horizontally" } },

	--[[ Normal mode editing shortcuts ]]
	{ "n", "<A-a>",     "ggVG",                                                               DefaultOpts { desc = icons.ui.Cursor .. " Select all" } },
	-- Move current line / block with Alt-j/k a la vscode.
	{ "n", "<A-k>",     "<CMD>move .-2<CR>==",                                                DefaultOpts { desc = icons.ui.MoveUp .. " Move line up" } },
	{ "n", "<A-j>",     "<CMD>move .+1<CR>==",                                                DefaultOpts { desc = icons.ui.MoveDown .. " Move line down" } },
	-- Indentation and whitespace formatting
	{ "n", "<leader>=", function() require("utils.editing").silent_auto_indent() end,         DefaultOpts { desc = icons.ui.Indent .. " Auto-indent file" } },

	--[[ Word info ]]
	["g<C-g>"] = { icons.ui.Note .. " Count lines, words, and characters" },

	--[[ Insert mode editing shortcuts ]]
	{ "i",          "<A-a>", "<ESC>ggVG",           DefaultOpts { desc = icons.ui.Cursor .. " Select all" } },
	{ "i",          "<A-j>", "<Esc>:m .+1<CR>==gi", DefaultOpts { desc = icons.ui.MoveDown .. " Move line down" } },
	{ "i",          "<A-k>", "<Esc>:m .-2<CR>==gi", DefaultOpts { desc = icons.ui.MoveUp .. " Move line up" } },
	{ "i",          "<F3>",  "<CMD>noh<CR>",        DefaultOpts { desc = "Turn off search highlights" } },
	{ "i",          "<A-,>", "<C-D>",               DefaultOpts { desc = icons.ui.IndentDecrease .. " Decrease indentation" } },
	{ "i",          "<A-.>", "<C-T>",               DefaultOpts { desc = icons.ui.IndentIncrease .. " Increase indentation" } },
	{ "i",          "<C-j>", "<Down>",              DefaultOpts { desc = "Move cursor down" } },
	{ "i",          "<C-K>", "<Up>",                DefaultOpts { desc = "Move cursor up" } },
	{ "i",          "<C-h>", "<Left>",              DefaultOpts { desc = "Move cursor left" } },
	{ "i",          "<C-l>", "<Right>",             DefaultOpts { desc = "Move cursor right" } },

	--[[ visual block mode editing shortcuts ]]
	{ "x",          "<A-k>", ":m '<-2<CR>gv-gv",    DefaultOpts { desc = icons.ui.MoveUp .. " Move selection up" } },
	{ "x",          "<A-j>", ":m '>+1<CR>gv-gv",    DefaultOpts { desc = icons.ui.MoveDown .. " Move selection down" } },
	-- Indentation and whitespace formatting
	{ "x",          "<",     "<gv",                 DefaultOpts { desc = icons.ui.IndentDecrease .. " Decrease indent" } },
	{ "x",          ">",     ">gv",                 DefaultOpts { desc = icons.ui.IndentIncrease .. " Increase indent" } },

	--Searching
	{ { "n", "i" }, "<F3>",  "<CMD>noh<CR>",        DefaultOpts { desc = icons.ui.Highlight .. " Clear search highlights" } },

	--Find and replace (see also LSP keybinds)
	{
		"x",
		"<F2>",
		function()
			local k = vim.api.nvim_replace_termcodes(":s/", true, false, true)
			vim.api.nvim_feedkeys(k, "t", false)
		end,
		DefaultOpts { desc = icons.ui.FindAndReplace .. " Find and replace highlighted" }
	},
	{
		"n",
		"<F2>",
		function()
			local k = vim.api.nvim_replace_termcodes(":%s/<C-R><C-w>", true, false, true)
			vim.api.nvim_feedkeys(k, "t", false)
		end,
		DefaultOpts { desc = icons.ui.FindAndReplace .. " Find and replace", }
	},
	{
		"n",
		"<F2>",
		function()
			local k = vim.api.nvim_replace_termcodes(":%s/\\<<C-R><C-w>\\>", true, false, true)
			vim.api.nvim_feedkeys(k, "t", false)
		end,
		DefaultOpts { desc = icons.ui.FindAndReplace .. " Find and replace (whole word)" }
	},

	--[ Don't yank when replacing text ]
	-- paste without yanking
	{
		"x",
		"p",
		function()
			if vim.fn.mode() == "v" then -- note that 'v' here is charwise visual, not visual + select
				vim.api.nvim_feedkeys([["_dhp]], "n", true)
			elseif vim.fn.mode() == "V" then
				vim.api.nvim_feedkeys([["_dP]], "n", true)
			end
		end,
		DefaultOpts { noremap = true },
	},
	-- correct without yanking
	{ { "x", "n" }, "c", [["_c]], DefaultOpts { noremap = true } },
}

---@type table<string, table>
local which_key_defaults = {
	leader    = {
		["<Leader>"] = {
			name = icons.ui.Files .. " Leader shortcuts",
			["L"] = { icons.ui.Lightbulb .. " LSP" },
			["D"] = { name = require("icons").debug.Debug .. " Debug" },
			["`"] = { name = icons.ui.Terminal .. " Terminals" },
			["s"] = { name = icons.ui.Gear .. " Settings" },
			["f"] = { name = icons.ui.Files .. " Files" },
			["P"] = { name = icons.ui.ToolBox .. " Plugins" },
			["b"] = { name = icons.ui.Files .. " Buffers" },
			["g"] = { name = icons.git.Git .. " Git" },
			["t"] = { name = icons.ui.Tab .. " Tabs" },
			["k"] = { name = icons.ui.Project .. " Workspaces" },
			["l"] = { name = icons.ui.Diagnostics .. " Diagnostics" },
		},
	},
	windows   = {
		["<C-w>"] = {
			name = icons.ui.Window .. " Manage windows",
			["H"] = { name = icons.ui.ChevronLeftBoxOutline .. " Go to the left window", },
			["J"] = { name = icons.ui.ChevronDownBoxOutline .. " Go to the down window", },
			["K"] = { name = icons.ui.ChevronUpBoxOutline .. " Go to the up window", },
			["L"] = { name = icons.ui.ChevronRightBoxOutline .. " Go to the right window", },
		},
	},
	searching = {
		["*"]  = { name = icons.ui.Search .. " Search forwards (whole word)", mode = { "n", "x", "o" }, },
		["#"]  = { name = icons.ui.Search .. " Search backwards (whole word)", mode = { "n", "x", "o" }, },
		["g*"] = { name = icons.ui.Search .. " Search forwards", mode = { "n", "x", "o" }, },
		["g#"] = { name = icons.ui.Search .. " Search backwards", mode = { "n", "x", "o" }, },
	},
	misc      = {
		["g<C-g>"] = { name = icons.ui.Note .. " Count lines, words, and characters", mode = { "n", "x" } },
		["Y"] = { name = "Yank to end of line" },
	}
}

M.autocmd_keybinds = {
	{
		"FileType",
		{
			desc = "Make q close the window in certain UI buffers",
			group = "q_is_close_keybinding",
			pattern = {
				"qf",
				"help",
				"man",
				"floaterm",
				"mason",
				"Trouble",
				"alpha",
			},
			callback = function()
				vim.keymap.set("n", "q", "<cmd>close<cr>",
					DefaultOpts { desc = icons.ui.BoldClose .. " Close window", buffer = true })
			end,
		},
	},
}

function M.load_defaults()
	for _, v in ipairs(M.keymaps) do
		vim.keymap.set(table.unpack(v))
	end
	vim.g.which_key_defaults = which_key_defaults
	require("autocmds").define_autocmds(M.autocmd_keybinds)
end

return M
