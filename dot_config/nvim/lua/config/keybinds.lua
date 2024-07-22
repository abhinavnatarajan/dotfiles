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
	{
		"n",
		"<leader>W",
		"<CMD>wa!<CR>",
		DefaultOpts({ desc = icons.ui.SaveAll .. " Save all" }),
	},
	{
		"n",
		"<leader>q",
		"<CMD>confirm qa<CR>",
		DefaultOpts({ desc = icons.ui.BoldClose .. " Quit with confirmation" }),
	},
	{
		"n",
		"<leader>Q",
		"<CMD>qa!<CR>",
		DefaultOpts({ desc = icons.ui.BoldClose .. " Quit" }),
	},
	{
		"n",
		"<leader>%",
		"<CMD>cd %:p:h<CR>",
		DefaultOpts({ desc = icons.ui.FolderActive .. " Set working directory from active buffer" }),
	},
	{
		"n",
		"<leader>-",
		"<CMD>cd ..<CR>",
		DefaultOpts({ desc = icons.ui.FolderUp .. " Go up one directory" }),
	},
	{
		"n",
		"<leader>C",
		"q:",
		DefaultOpts({ desc = icons.ui.Terminal .. " Command history" }),
	},
	{
		"n",
		"<leader>si",
		function()
			require("utils.editing").select_indent(false)
		end,
		DefaultOpts({ desc = icons.ui.Indent .. " Set indentation" }),
	},
	{
		"n",
		"<leader>fi",
		function()
			require("utils.editing").select_indent(true)
		end,
		DefaultOpts({ desc = icons.ui.Indent .. " Set buffer indentation" }),
	},
	{
		"n",
		"<leader>fn",
		function()
			require("utils.windows").edit_new_file_handler()
		end,
		DefaultOpts({ desc = icons.ui.NewFile .. " New file" }),
	},
	{
		"n",
		"<leader>fm",
		function()
			require("utils.editing").choose_file_newline()
		end,
		DefaultOpts({ desc = icons.ui.ReturnCharacter .. " Set newline format" }),
	},
	{
		"n",
		"<leader>Pm",
		function()
			require("lazy").home()
		end,
		DefaultOpts({ desc = icons.ui.Configure .. " Manage plugins" }),
	},
	{
		"n",
		"<leader>x",
		function()
			require("utils.component_manager").hide_all()
		end,
		DefaultOpts({ desc = icons.ui.ChevronDoubleDown .. " Hide lists/terminals" }),
	},

	--[[ Tab management ]]
	{
		{ "n", "i" },
		"<A-t>",
		"<CMD>tabn<CR>",
		DefaultOpts({ desc = icons.ui.ArrowRight .. " Next tab" }),
	},
	{
		{ "n", "i" },
		"<A-T>",
		"<CMD>tabN<CR>",
		DefaultOpts({ desc = icons.ui.ArrowLeft .. " Previous tab" }),
	},
	{
		"n",
		"<leader>te",
		"<CMD>tab split<CR>",
		DefaultOpts({ desc = icons.ui.Edit .. " Edit in new tab" }),
	},
	{
		"n",
		"<leader>to",
		"<CMD>tabonly<CR>",
		DefaultOpts({ desc = "Close all other tabs" }),
	},
	{
		"n",
		"<leader>tn",
		"<CMD>tab split<CR>",
		DefaultOpts({ desc = icons.ui.OpenInNew .. " New file in new tab" }),
	},
	{
		"n",
		"<leader>tc",
		"<CMD>tabclose<CR>",
		DefaultOpts({ desc = "Close current tab" }),
	},
	{
		"n",
		"<leader>tH",
		"<CMD>silent! tabmove -1<CR>",
		DefaultOpts({ desc = icons.ui.BoldArrowLeft .. " Move tab to the left" }),
	},
	{
		"n",
		"<leader>tL",
		"<CMD>silent! tabmove +1<CR>",
		DefaultOpts({ desc = icons.ui.BoldArrowRight .. " Move tab to the right" }),
	},
	{
		"n",
		"<leader>tf",
		"<CMD>tabs<CR>",
		DefaultOpts({ desc = icons.ui.FindTab .. " Find tabs" }),
	},
	{
		"n",
		"<leader>tj",
		function()
			vim.cmd("silent! tabnext" .. vim.v.count1)
		end,
		{ desc = "Jump to tab" },
	},
	{
		"t",
		"<Esc>",
		[[<C-\><C-n>]],
		DefaultOpts({ desc = "Normal mode" }),
	},
	{
		"n",
		"gx",
		function()
			vim.system({ "open", vim.fn.expand("<cfile>") }, { timeout = 1000, text = true }, function(task) -- on_exit
				if task.code ~= 0 then
					vim.notify(task.stderr, vim.log.levels.ERROR)
				end
			end)
		end,
		DefaultOpts({ desc = icons.ui.Window .. " Open in external program" }),
	},

	--[[ Window navigation and resizing ]]
	-- Resize with arrows
	{
		"n",
		"<C-Up>",
		"<CMD>silent resize +2<CR>",
		DefaultOpts({ desc = icons.ui.ExpandVertical .. " Shrink window vertically" }),
	},
	{
		"n",
		"<C-Down>",
		"<CMD>silent resize -2<CR>",
		DefaultOpts({ desc = icons.ui.ExpandVertical .. " Expand window vertically" }),
	},
	{
		"n",
		"<C-Left>",
		"<CMD>silent vertical resize -2<CR>",
		DefaultOpts({ desc = icons.ui.ExpandHorizontal .. " Shrink window horizontally" }),
	},
	{
		"n",
		"<C-Right>",
		"<CMD>silent vertical resize +2<CR>",
		DefaultOpts({ desc = icons.ui.ExpandHorizontal .. " Expand window horizontally" }),
	},

	--[[ Motions ]]
	{
		{ "n", "x", "o" },
		"w",
		function()
			require("utils.motions").motion("w")
		end,
		DefaultOpts({ desc = "Next word" }),
	},
	{
		{ "n", "x", "o" },
		"e",
		function()
			require("utils.motions").motion("e")
		end,
		DefaultOpts({ desc = "Next end of word" }),
	},
	{
		{ "n", "x", "o" },
		"b",
		function()
			require("utils.motions").motion("b")
		end,
		DefaultOpts({ desc = "Prev word" }),
	},
	{
		{ "n", "x", "o" },
		"ge",
		function()
			require("utils.motions").motion("ge")
		end,
		DefaultOpts({ desc = "Prev end of word" }),
	},
	{
		{ "n", "o", "x" },
		"<C-j>", "gj", DefaultOpts { desc = "Move down one screen line" }
	},
	{
		{ "n", "o", "x" },
		"<C-k>", "gk", DefaultOpts { desc = "Move down one screen line" }
	},

	--[[ Text objects ]]
	{
		{ "o", "x" },
		"i_",
		"<Plug>(textobject-iw)",
		DefaultOpts({ desc = "Inside word" }),
	},
	{
		{ "o", "x" },
		"a_",
		"<Plug>(textobject-aw)",
		DefaultOpts({ desc = "Around word" }),
	},
	{
		{ "o", "x" },
		"il",
		"<Plug>(textobject-il)",
		DefaultOpts({ desc = "Inside line" }),
	},
	{
		{ "o", "x" },
		"al",
		"<Plug>(textobject-al)",
		DefaultOpts({ desc = "Around line" }),
	},

	--[[ Move lines around a la vscode ]]
	{
		{ "n", "i" },
		"<A-j>",
		function()
			return "<CMD>silent m .+" .. vim.v.count1 .. " | silent normal ==<CR>"
		end,
		DefaultOpts({ desc = icons.ui.MoveUp .. " Move line down", expr = true }),
	},
	{
		{ "n", "i" },
		"<A-k>",
		function()
			return "<CMD>silent m .-" .. (vim.v.count1 + 1) .. " | silent normal ==<CR>"
		end,
		DefaultOpts({ desc = icons.ui.MoveUp .. " Move line up", expr = true }),
	},
	{
		"x",
		"<A-j>",
		function()
			return "<Esc><CMD>silent '<,'>m '>+" .. vim.v.count1 .. "<CR>gv=gv"
		end,
		DefaultOpts({ desc = icons.ui.MoveUp .. " Move selection down", expr = true }),
	},
	{
		"x",
		"<A-k>",
		function()
			return "<Esc><CMD>silent '<,'>m '<-" .. (vim.v.count1 + 1) .. "<CR>gv=gv"
		end,
		DefaultOpts({ desc = icons.ui.MoveUp .. " Move selection up", expr = true }),
	},

	--[[ Normal mode editing shortcuts ]]
	{
		"n",
		"<A-a>",
		"ggVG",
		DefaultOpts({ desc = icons.ui.Cursor .. " Select all" }),
	},
	-- Indentation and whitespace formatting
	{
		"n",
		"<leader>=",
		function()
			require("utils.editing").silent_auto_indent()
		end,
		DefaultOpts({ desc = icons.ui.Indent .. " Auto-indent file" }),
	},

	--[[ Word info ]]
	["g<C-g>"] = { icons.ui.Note .. " Count lines, words, and characters" },

	--[[ Insert mode editing shortcuts ]]
	{
		"i",
		"<A-a>",
		"<ESC>ggVG",
		DefaultOpts({ desc = icons.ui.Cursor .. " Select all" }),
	},
	{
		"i",
		"<F3>",
		"<CMD>noh<CR>",
		DefaultOpts({ desc = "Turn off search highlights" }),
	},
	{
		"i",
		"<A-,>",
		"<C-D>",
		DefaultOpts({ desc = icons.ui.IndentDecrease .. " Decrease indentation" }),
	},
	{
		"i",
		"<A-.>",
		"<C-T>",
		DefaultOpts({ desc = icons.ui.IndentIncrease .. " Increase indentation" }),
	},
	{ "i", "<C-j>", "<Down>",  DefaultOpts({ desc = "Move cursor down" }) },
	{ "i", "<C-K>", "<Up>",    DefaultOpts({ desc = "Move cursor up" }) },
	{ "i", "<C-h>", "<Left>",  DefaultOpts({ desc = "Move cursor left" }) },
	{ "i", "<C-l>", "<Right>", DefaultOpts({ desc = "Move cursor right" }) },
	{ "i", "<Esc>", "<Esc>`^" }, -- don't move the cursor after leaving insert mode

	--[[ visual mode editing shortcuts ]]
	-- Indentation and whitespace formatting
	{
		"x",
		"<",
		[[<CMD>exe "silent normal! \<gv"<CR>]],
		DefaultOpts({ desc = icons.ui.IndentDecrease .. " Decrease indent" }),
	},
	{
		"x",
		">",
		[[<CMD>exe "silent normal! >gv"<CR>]],
		DefaultOpts({ desc = icons.ui.IndentIncrease .. " Increase indent" }),
	},

	--Searching
	{
		{ "n", "i" },
		"<F3>",
		"<CMD>noh<CR>",
		DefaultOpts({ desc = icons.ui.Highlight .. " Clear search highlights" }),
	},

	--Find and replace (see also LSP keybinds)
	{
		"x",
		"<F2>",
		function()
			local k = vim.api.nvim_replace_termcodes(":s/", true, false, true)
			vim.api.nvim_feedkeys(k, "t", false)
		end,
		DefaultOpts({ desc = icons.ui.FindAndReplace .. " Find and replace highlighted" }),
	},
	{
		"n",
		"<F2>",
		function()
			local k = vim.api.nvim_replace_termcodes(":%s/<C-R><C-w>", true, false, true)
			vim.api.nvim_feedkeys(k, "t", false)
		end,
		DefaultOpts({ desc = icons.ui.FindAndReplace .. " Find and replace" }),
	},
	{
		"n",
		"<F2>",
		function()
			local k = vim.api.nvim_replace_termcodes(":%s/\\<<C-R><C-w>\\>", true, false, true)
			vim.api.nvim_feedkeys(k, "t", false)
		end,
		DefaultOpts({ desc = icons.ui.FindAndReplace .. " Find and replace (whole word)" }),
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
		DefaultOpts({ noremap = true }),
	},
	-- correct without yanking
	{ { "x", "n" }, "c", [["_c]], DefaultOpts({ noremap = true }) },
}

---@type table<string, table>
M.which_key_defaults = {
	{ "<Leader>",  group = icons.ui.Files .. " Leader shortcuts" },
	{ "<Leader>L", group = icons.ui.Lightbulb .. " LSP" },
	{ "<Leader>D", group = icons.debug.Debug .. " Debug" },
	{ "<Leader>s", group = icons.ui.Gear .. " Settings" },
	{ "<Leader>f", group = icons.ui.Files .. " Files" },
	{ "<Leader>P", group = icons.ui.ToolBox .. " Plugins" },
	{ "<Leader>b", group = icons.ui.Files .. " Buffers" },
	{ "<Leader>t", group = icons.ui.Tab .. " Tabs" },
	{ "<C-w>",     group = icons.ui.Window .. " Manage windows" },
	{ "<C-w>H",    group = icons.ui.ChevronLeftBoxOutline .. " Go to the left window" },
	{ "<C-w>J",    group = icons.ui.ChevronDownBoxOutline .. " Go to the down window" },
	{ "<C-w>K",    group = icons.ui.ChevronUpBoxOutline .. " Go to the up window" },
	{ "<C-w>L",    group = icons.ui.ChevronRightBoxOutline .. " Go to the right window" },
	{ "*",         group = icons.ui.Search .. " Search forwards (whole word)",          mode = { "n", "x", "o" } },
	{ "#",         group = icons.ui.Search .. " Search backwards (whole word)",         mode = { "n", "x", "o" } },
	{ "g*",        group = icons.ui.Search .. " Search forwards",                       mode = { "n", "x", "o" } },
	{ "g#",        group = icons.ui.Search .. " Search backwards",                      mode = { "n", "x", "o" } },
	{ "g<C-g>",    group = icons.ui.Note .. " Count lines, words, and characters",      mode = { "n", "x" } },
	{ "Y",         group = "Yank to end of line" },
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
				vim.keymap.set(
					"n",
					"q",
					"<cmd>close<cr>",
					DefaultOpts({ desc = icons.ui.BoldClose .. " Close window", buffer = true })
				)
			end,
		},
	},
}

function M.load_defaults()
	for _, v in ipairs(M.keymaps) do
		vim.keymap.set(table.unpack(v))
	end
	require("autocmds").define_autocmds(M.autocmd_keybinds)
end

return M
