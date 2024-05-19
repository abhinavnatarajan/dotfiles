local M = {}

function M.load_defaults()
	local icons = require("icons")
	local global_defaults = {
		-- opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
		-- shadafile       = join_paths(get_cache_dir(), "lvim.shada"),
		autochdir      = false,   -- do not change cwd on file open
		backup         = false,   -- creates a backup file
		breakat        = " ^!@*-+;,/?",
		breakindent    = true,
		cindent        = false,                                 -- smart indenting for new lines
		-- cinkeys            = "0{,0},0),0],:,0#,!^F,o,O,e",
		clipboard      = "unnamedplus",                         -- allows neovim to access the system clipboard
		cmdheight      = 1,                                     -- more space in the neovim command line for displaying messages
		completeopt    = { "menu", "menuone", "noselect", "longest", },
		conceallevel   = 2,                                     -- so that `` is visible in markdown files
		cpoptions      = "aABceFWZ_",
		cursorline     = true,                                  -- highlight the current line
		expandtab      = false,                                 -- convert tabs to spaces
		fileencoding   = "utf-8",                               -- the encoding written to a file
		foldenable     = false,
		foldexpr       = "nvim_treesitter#foldexpr()",          -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
		foldmethod     = "expr",                                -- folding, set to "expr" for treesitter based folding
		guifont        = { "JetBrainsMono Nerd Font", ":h11" }, -- the font used in graphical neovim applications
		-- guioptions         = "mr", -- m for menubar, r for right scrollbar
		hidden         = true,                                  -- required to keep multiple buffers and open multiple buffers
		hlsearch       = true,                                  -- highlight all matches on previous search pattern
		ignorecase     = true,                                  -- ignore case in search patterns
		-- indentkeys         = "0{,0},0),0],:,0#,!^F,o,O,e",
		jumpoptions    = { "stack", "view" },
		keywordprg     = ":vert help",
		laststatus     = 3,
		linebreak      = true,
		list           = true,
		matchpairs     = { "{:}", "(:)", "[:]" },
		mouse          = "a",    -- allow the mouse to be used in neovim
		mousemoveevent = true,
		number         = true,   -- set numbered lines
		numberwidth    = 3,      -- set number column width to 2 {default 4}
		pumblend       = 8,      -- translucent popup menu
		pumheight      = 150,    -- pop up menu height
		relativenumber = true,   -- set relative numbered lines
		ruler          = false,
		scrolloff      = 4,      -- minimal number of screen lines to keep above and below the cursor.
		sessionoptions = {
			"blank",
			"buffers",
			"curdir",
			"folds",
			"help",
			"localoptions",
			"tabpages",
			"terminal",
			"winpos",
			"winsize",
		},
		shiftwidth     = 0,                                      -- the number of spaces inserted for each indentation (0 to match tabstop)
		showcmd        = false,
		showmode       = true,                                   -- INSERT/VISUAL etc
		sidescrolloff  = 4,                                      -- minimal number of screen lines to keep left and right of the cursor.
		-- signcolumn         = "yes:3", -- one for git, one for LSP, and one for breakpoints
		smartcase      = true,                                   -- smart case
		splitbelow     = true,                                   -- force all horizontal splits to go below current window
		splitright     = true,                                   -- force all vertical splits to go to the right of current window
		swapfile       = false,                                  -- creates a swapfile
		tabstop        = 2,                                      -- insert 2 spaces for a tab
		termguicolors  = true,                                   -- set term gui colors (most terminals support this)
		timeout        = true,
		timeoutlen     = 500,                                    -- time to wait for a mapped sequence to complete (in milliseconds)
		title          = true,                                   -- set the title of window to the value of the titlestring
		undodir        = vim.fn.stdpath("state") .. "/undo//",   -- set an undo directory
		undofile       = true,                                   -- enable persistent undo
		updatetime     = 100,                                    -- faster completion
		whichwrap      = '<>[]lh',
		winblend       = 8,                                      -- translucent floating windows
		wrap           = true,                                   -- display lines as one long line
		writebackup    = false,                                  -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	}
	-- set global defaults
	for k, v in pairs(global_defaults) do
		vim.opt[k] = v
	end
	local global_defaults_extend = {
		fillchars = {
			foldopen = icons.ui.TriangleShortArrowDown,
			foldclose = icons.ui.TriangleShortArrowRight,
			foldsep = '┊',
			eob = " "
		},
		listchars = {
			lead = icons.ui.DotSmall,
			-- space = icons.ui.DotSmall,
			multispace = icons.ui.DotSmall,
			trail = '-',
			eol = icons.ui.Eol,
			tab = '>' .. icons.ui.DotSmall
		}
	}
	-- Extend defaults
	for k, v in pairs(global_defaults_extend) do
		vim.opt[k] = vim.tbl_extend("force", vim.opt[k]:get(), v)
	end
	vim.g.python3_host_prog    = '/home/abhinav/.pyenv/versions/pynvim/bin/python'
	vim.g.loaded_ruby_provider = 0
	vim.g.loaded_perl_provider = 0
	vim.g.mapleader            = " "
	vim.g.maplocalleader       = "\\"
	-- if using neovide GUI
	if vim.g.neovide then
		-- vim.g.neovide_scale_factor = 0.78
		vim.g.neovide_remember_window_size = true
		vim.g.neovide_cursor_animation_length = 0.02
		vim.g.neovide_scroll_animation_far_lines = 9999
		vim.g.neovide_unlink_border_highlights = true
		vim.g.neovide_cursor_trail_size = 0.5
		vim.o.winblend = 25
		vim.g.neovide_scroll_animation_length = 0.2
		vim.g.neovide_unlink_border_highlights = true
		vim.g.pumblend = 25
		vim.g.neovide_floating_blur_amount_x = 5.0
		vim.g.neovide_floating_blur_amount_y = 5.0
		vim.keymap.set({ 'n', 'i', 'v', 'x', 't' }, '<F11>',
			function() vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen end, { noremap = true })
	end


	-- set powershell options on windows
	if vim.fn.has('win32') then
		local powershell_opts = {
			shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
			shellcmdflag =
			"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
			shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
			shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
			shellquote = "",
			shellxquote = "",
		}
		for k, v in ipairs(powershell_opts) do
			vim.opt[k] = v
		end
	end
	-- set local defaults via autocommands
	local local_defaults = {
		{
			-- escape from terminal mode in toggleterm
			"TermOpen",
			{
				group = "no_signs_in_toggleterm",
				pattern = "term://*toggleterm#*",
				callback = function()
					vim.opt_local.signcolumn = "no"
				end,
			}
		},
		{
			-- enable wrapping on Telescope previewers
			"User",
			{
				group = "wrap_telescope_previews",
				pattern = "TelescopePreviewerLoaded",
				callback = function()
					vim.wo.wrap = true
				end
			},
		},
	}
	require("autocmds").define_autocmds(local_defaults)
end

return M
