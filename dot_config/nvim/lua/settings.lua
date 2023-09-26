local M = {}

function M.load_defaults()
  local defaults = {
    -- opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
    -- shadafile       = join_paths(get_cache_dir(), "lvim.shada"),
    autochdir          = false, -- do not change cwd on file open
    backup             = false, -- creates a backup file
    breakat            = " ^!@*-+;,/?",
    breakindent        = true,
    cindent            = true, -- smart indenting for new lines
    clipboard          = "unnamedplus", -- allows neovim to access the system clipboard
    cmdheight          = 1, -- more space in the neovim command line for displaying messages
    completeopt        = { "menu", "menuone", "noselect", "longest", },
    conceallevel       = 0, -- so that `` is visible in markdown files
    cursorline         = true, -- highlight the current line
    expandtab          = true, -- convert tabs to spaces
    fileencoding       = "utf-8", -- the encoding written to a file
    foldenable         = false,
    foldexpr           = "nvim_treesitter#foldexpr()", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
    foldmethod         = "expr", -- folding, set to "expr" for treesitter based folding
    guifont            = "monospace:h17", -- the font used in graphical neovim applications
    hidden             = true, -- required to keep multiple buffers and open multiple buffers
    hlsearch           = true, -- highlight all matches on previous search pattern
    ignorecase         = true, -- ignore case in search patterns
    jumpoptions        = {"stack", "view"},
    keywordprg         = ":help",
    laststatus         = 3,
    linebreak          = true,
    mouse              = "a", -- allow the mouse to be used in neovim
    number             = true, -- set numbered lines
    numberwidth        = 3, -- set number column width to 2 {default 4}
    pumblend           = 8, -- translucent popup menu
    pumheight          = 150, -- pop up menu height
    ruler              = false,
    scrolloff          = 2, -- minimal number of screen lines to keep above and below the cursor.
    sessionoptions     = {
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
    shiftwidth         = 0, -- the number of spaces inserted for each indentation (0 to match tabstop)
    showcmd            = false,
    showmode           = true, -- INSERT/VISUAL etc
    sidescrolloff      = 4, -- minimal number of screen lines to keep left and right of the cursor.
    signcolumn         = "yes", -- always show the sign column, otherwise it would shift the text each time
    smartcase          = true, -- smart case
    splitbelow         = true, -- force all horizontal splits to go below current window
    splitright         = true, -- force all vertical splits to go to the right of current window
    swapfile           = false, -- creates a swapfile
    tabstop            = 2, -- insert 2 spaces for a tab
    termguicolors      = true, -- set term gui colors (most terminals support this)
    timeout            = true,
    timeoutlen         = 500, -- time to wait for a mapped sequence to complete (in milliseconds)
    title              = true, -- set the title of window to the value of the titlestring
    undodir            = vim.fn.stdpath("state") .. "nvim/undo//", -- set an undo directory
    undofile           = true, -- enable persistent undo
    updatetime         = 100, -- faster completion
    whichwrap          = '<>[]lh',
    winblend           = 8, -- translucent floating windows
    wrap               = true, -- display lines as one long line
    writebackup        = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  }
  for k, v in pairs(defaults) do
    vim.opt[k] = v
  end
  if vim.fn.has('win32') then
    local powershell_opts = {
      shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
      shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
      shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
      shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
      shellquote = "",
      shellxquote = "",
    }
    for k, v in ipairs(powershell_opts) do
      vim.opt[k] = v
    end
  end
  -- vim.opt.guioptions:append("b")
  vim.opt.fillchars:append("eob: ")
  vim.g.mapleader = " "
end

return M
