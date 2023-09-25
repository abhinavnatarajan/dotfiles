local M = {}

local neoscroll = require("neoscroll")
local DefaultOpts = require("utils").prototype {
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

M.defaults = {
  {
    -- File shortcuts
    mapping = {
      ["<leader>"] = {
        name = "File shortcuts",
        [";"] = { "<CMD>Alpha<CR>", "Dashboard" },
        ["n"] = { [[<CMD>lua require("telescope_custom_pickers").new_file()<CR>]], "New file" },
        ["w"] = { [[<CMD>lua require("telescope_custom_pickers").check_save_as()<CR>]], "Save" },
        ["<C-w>"] = { [[<CMD>lua require("telescope_custom_pickers").save_as()<CR>]], "Save as" },
        ["W"] = { "<CMD>wa!<CR>", "Save all" },
        ["c"] = { "<CMD>confirm Bdelete<CR>", "Close buffer" },
        ["e"] = { "<CMD>silent NvimTreeToggle<CR>", "Explorer" },
        ["q"] = { "<CMD>confirm q<CR>", "Close window" },
        ["Q"] = { "<CMD>qa!<CR>", "Quit" },
        ["%"] = { "<CMD>cd %:p:h<CR>", "Set working directory from active buffer" },
        ["-"] = { "<CMD>cd ..<CR>", "cd .." },
        ["h"] = { "<CMD>Telescope help_tags<CR>", "Search in help topics" },
        ["\\"] = { "<CMD>Telescope notify<CR>", "Notification history" },
        ["s"] = {
          name = "Settings",
          ["c"] = { "<CMD>Telescope colorscheme enable_preview=true<CR>", "Colorscheme" },
          ["f"] = { [[lua require("telescope_custom_pickers").config]], "Browse config files" },
        },
        ["k"] = {
          name = "Workspaces",
          ["f"] = { [[<CMD>SessionManager load_session<CR>]],"Find workspace" },
          ["w"] = { "<CMD>SessionManager save_current_session<CR>", "Save current workspace" },
        },
        ["f"] = {
          name = "Files",
          ["f"] = { [[<CMD>lua require("telescope_custom_pickers").smart_find_files()<CR>]], "Find files in cwd" },
          ["d"] = { "<CMD>Telescope file_browser<CR>", "Browse files" },
          ["g"] = { [[<CMD>lua require("telescope_custom_pickers").live_grep()<CR>]], "Search text" },
          ["r"] = { [[<CMD>lua require("telescope_custom_pickers").oldfiles()<CR>]], "Recent files" },
        },
        ["P"] = {
          name = "Plugins",
          ["m"] = { "<CMD>Lazy home<CR>", "Manage plugins" },
          ["f"] = { "<CMD>Telescope lazy<CR>", "Explore plugin files" },
        },
        ["b"] = {
          name = "Buffers",
          ["j"] = { "<CMD>BufferLinePick<CR>", "Jump to buffer" },
          ["f"] = { [[<CMD> lua require("telescope_custom_pickers").buffers()<CR>]], "Find buffer" },
          ["p"] = { "<CMD>BufferLineTogglePin<CR>", "Pin buffer" },
        },
        ["gg"] = { "<CMD>LazyGit<CR>", "Lazy git UI" },
        ["x"] = {
          name = "Diagnostics",
          ["x"] = { "<CMD>TroubleToggle<CR>", "Toggle diagnostics" },
          ["w"] = { "<CMD>TroubleToggle workspace_diagnostics<CR>", "Workspace diagnostics" },
          ["d"] = { "<CMD>TroubleToggle document_diagnostics<CR>", "Document diagnostics" },
          ["q"] = { "<CMD>TroubleToggle quickfix<CR>", "Quickfix" },
          ["l"] = { "<CMD>TroubleToggle loclist<CR>", "Location list" },
        },
        ["L"] = {
          name="LSP",
          ["m"] = { "<CMD>Mason<CR>", "Manage installed LSP servers" },
          ["i"] = { "<CMD>LspInfo<CR>", "LSP Info" },
        },
        ["t"] = {
          name="Tabs",
          ["e"] = { "<CMD>tab split<CR>", "Edit in new tab" },
          ["o"] = { "<CMD>tabonly<CR>", "Close all other tabs" },
          ["n"] = { "<CMD>tab split<CR>", "New file in new tab" },
          ["c"] = { "<CMD>tab close<CR>", "Close current tab" },
          ["h"] = { "<CMD>silent! tabmove -1<CR>", "Move tab to the left" },
          ["l"] = { "<CMD>silent! tabmove +1<CR>", "Move tab to the right" },
          ["f"] = { "<CMD>tabs<CR>", "Find tabs" },
          ["j"] = {
            function() 
              vim.ui.input(
                {prompt = "Go to tab:" }, 
                function(input)
                  vim.cmd("silent! tabnext" .. input)
                end
              )
            end,
            "Jump to tab"
          }
        }
      },
      ["\\"] = {
        -- dismiss notifications
        function()
          require('notify').dismiss({pending = true, silent=true})
        end,
        "Dismiss notifications"
      },
    }
  },

  {
    -- Window navigation and resizing
    mapping = {
      -- Buffer movement
      ["<A-h>"] = { "<CMD>BufferLineCyclePrev<CR>", "Previous buffer" },
      ["<A-l>"] = { "<CMD>BufferLineCycleNext<CR>", "Next buffer" },
      ["<A-H>"] = { "<CMD>BufferLineMovePrev<CR>", "Move buffer left" },
      ["<A-L>"] = { "<CMD>BufferLineMoveNext<CR>", "Move buffer right" },
      -- Window movement
      ["<C-h>"] = { "<C-w>h", "Go to the left window" },
      ["<C-j>"] = { "<C-w>j", "Go to the down window" },
      ["<C-k>"] = { "<C-w>k", "Go to the up window" },
      ["<C-l>"] = { "<C-w>l", "Go to the right window" },
      -- Tab movement
      ["<A-C-h>"] = { "<CMD>tabprevious<CR>", "Previous tab" },
      ["<A-C-l>"] = { "<CMD>tabnext<CR>", "Next tab" },
      -- Smooth scrolling
      ["<C-y>"] = {
        function() neoscroll.scroll(-0.1, true, 100) end,
        "Scroll up 10% of window height",
      },
      ["<C-u>"] = {
        function() neoscroll.scroll(-vim.wo.scroll, true, 350) end,
        "Scroll up",
      },
      ["<C-e>"] = {
        function() neoscroll.scroll(0.1, true, 100) end,
        "Scroll down 10% of window height",
      },
      ["<C-d>"] = {
        function() neoscroll.scroll(vim.wo.scroll, true, 350) end,
        "Scroll down",
      },
      ["<C-b>"] = {
        function()
          neoscroll.scroll(-vim.api.nvim_win_get_height(0), true, 550)
        end,
        "Page up",
      },
      ["<C-f>"] = {
        function()
          neoscroll.scroll(vim.api.nvim_win_get_height(0), true, 550)
        end,
        "Page down",
      },
      ["zz"] = { function() neoscroll.zz(200) end, "Centre cursor line in window" },
      ["zt"] = { function() neoscroll.zt(200) end, "Align cursor line with top of window" },
      ["zb"] = { function() neoscroll.zb(200) end, "Align cursor line with bottom of window" },
      -- Resize with arrows
      ["<C-Up>"] = { "<CMD>resize +2<CR>", "Shrink window vertically" },
      ["<C-Down>"] = { "<CMD>resize -2<CR>", "Expand window vertically" },
      ["<C-Left>"] = { "<CMD>vertical resize -2<CR>", "Shrink window horizontally" },
      ["<C-Right>"] = { "<CMD>vertical resize +2<CR>", "Expand window horizontally" },
    }
  },

  {
    -- Normal mode editing shortcuts
    mapping = {
      -- Move current line / block with Alt-j/k a la vscode.
      ["<A-k>"] = { "<CMD>move .-2<CR>==", "Move line up" },
      ["<A-j>"] = { "<CMD>move .+1<CR>==", "Move line down" },
      ["<A-/>"] = { "<Plug>(comment_toggle_linewise_current)", "Toggle comment" },
      -- QuickFix
      ["]q"] = { "<CMD>cnext<CR>", "Next error" },
      ["[q"] = { "<CMD>cprev<CR>", "Previous error" },
      ["<C-q>"] = { "<CMD>call QuickFixToggle()<CR>", "Toggle quickfix" },
      -- Indentation and whitespace formatting
      ["<leader>="] = { require("utils").silent_auto_indent, "Auto-indent file" },
      ["<leader>$"] = { require("utils").remove_trailing_whitespace, "Remove trailing whitespace" },
      ["ga"] = { "<Plug>(EasyAlign)", "Align lines" },
      ["gA"] = { "<Plug>(LiveEasyAlign)", "Align lines with preview" },
      -- Delimiter formatting
      ["ys"] = { "<Plug>(nvim-surround-normal)", "Surround" },
      ["yss"] = { "<Plug>(nvim-surround-normal-cur)", "Surround line" },
      ["yS"] = { "<Plug>(nvim-surround-normal-line)", "Surround on new lines" },
      ["ySS"] = { "<Plug>(nvim-surround-normal-cur-line)", "Surround line on new lines" },
      ["ds"] = { "<Plug>(nvim-surround-delete)", "Delete delimiter" },
      ["cs"] = { "<Plug>(nvim-surround-change)", "Change delimiter" },
      -- Find and replace
      ["<F2>"] = {
        function()
          local k = vim.api.nvim_replace_termcodes(":%s/<C-R><C-w>", true, false, true)
          vim.api.nvim_feedkeys(k, "t", false)
        end,
        "Find and replace"
      },
      ["<F50>"] = {
        function()
          local k = vim.api.nvim_replace_termcodes(":%s/\\<<C-R><C-w>\\>", true, false, true)
          vim.api.nvim_feedkeys(k, "t", false)
        end,
        "Find and replace (whole word)"
      },
      ["<F3>"] = { "<CMD>noh<CR>", "Clear search highlights" },
      ["*"] = { "Search forwards (whole word)" },
      ["#"] = { "Search backwards (whole word)" },
      ["g*"] = { "Search forwards" },
      ["g#"] = { "Search backwards" },
      -- provided by vim-illuminate
      -- already documented, just putting it here so I know it exists
      -- ["<A-n>"] = { "Go to next reference under cursor" },
      -- ["<A-p>"] = { "Go to previous reference under cursor" },
    },
  },

  {
    -- insert mode editing shorcuts
    mode = "i",
    mapping = {
      ["<A-j>"] = { "<Esc>:m .+1<CR>==gi", "Move line down" },
      ["<A-k>"] = { "<Esc>:m .-2<CR>==gi", "Move line up" },
      ["<A-/>"] = { "<Esc>gccgi", "Toggle comment", noremap = false},
      -- Delimiter formatting
      -- ["<C-g>s"] = { "<Plug>(nvim-surround-insert)", "Surround" },
      -- ["<C-g>S"] = { "<Plug>(nvim-surround-insert-line)", "Surround on new lines" },
    },
  },
  {
    -- visual block mode editing shortcuts
    mode = "x",
    mapping = {
      ["<A-k>"] = { ":m '<-2<CR>gv-gv", "Move selection up" },
      ["<A-j>"] = { ":m '>+1<CR>gv-gv", "Move selection down" },
      ["<A-/>"] = { "<Plug>(comment_toggle_linewise_visual)gv", "Toggle comment" },
      -- Delimiter formatting
      ["<A-s>"] = { "<Plug>(nvim-surround-visual)", "Surround" },
      ["<A-S>"] = { "<Plug>(nvim-surround-visual-line)", "Surround on new lines" },
      -- Indentation and whitespace formatting
      ["<"] = { "<gv", "Decrease indent" },
      [">"] = { ">gv", "Increase indent" },
      ["ga"] = { "<Plug>(EasyAlign)", "Align lines" },
      ["gA"] = { "<Plug>(LiveEasyAlign)", "Align lines with preview" },
      ["<F2>"] = {
        function()
          local k = vim.api.nvim_replace_termcodes(":s/", true, false, true)
          vim.api.nvim_feedkeys(k, "t", false)
        end,
        "Find and replace highlighted"
      },
    }
  },
  {
    -- operator-pending mode mappings
    mode = "o",
    mapping = {
      ["<A-i>"] = { "LSP object under cursor" } -- provided by vim-illuminate
    },
  },
  {
    -- Debugger
    mappings = {
      ["<F5>"] = {
        name = "Debug",
        ["t"] = { [[<CMD>lua require"dap".toggle_breakpoint()<CR>]], "Toggle Breakpoint" },
        ["b"] = { [[<CMD>lua require"dap".step_back()<CR>]], "Step Back" },
        ["c"] = { [[<CMD>lua require"dap".continue()<CR>]], "Continue" },
        ["C"] = { [[<CMD>lua require"dap".run_to_cursor()<CR>]], "Run To Cursor" },
        ["d"] = { [[<CMD>lua require"dap".disconnect()<CR>]], "Disconnect" },
        ["g"] = { [[<CMD>lua require"dap".session()<CR>]], "Get Session" },
        ["i"] = { [[<CMD>lua require"dap".step_into()<CR>]], "Step Into" },
        ["o"] = { [[<CMD>lua require"dap".step_over()<CR>]], "Step Over" },
        ["u"] = { [[<CMD>lua require"dap".step_out()<CR>]], "Step Out" },
        ["p"] = { [[<CMD>lua require"dap".pause()<CR>]], "Pause" },
        ["r"] = { [[<CMD>lua require"dap".repl.toggle()<CR>]], "Toggle Repl" },
        ["s"] = { [[<CMD>lua require"dap".continue()<CR>]], "Start" },
        ["q"] = { [[<CMD>lua require"dap".close()<CR>]], "Quit" },
        ["U"] = { [[<CMD>lua require"dapui".toggle({reset = true})<CR>]], "Toggle UI" },
      }
    }
  },
  {
    -- Terminal mode mappings
    mode = "t",
    mapping = {
      ["<C-k>"] = { "<C-\\><C-N><C-w>k", "Go to the up window" },
      ["<C-j>"] = { "<C-\\><C-N><C-w>j", "Go to the down window" },
      ["<C-h>"] = { "<C-\\><C-N><C-w>h", "Go to the left window" },
      ["<C-l>"] = { "<C-\\><C-N><C-w>l", "Go to the right window" }
    }
  },
}
function M.load_defaults()
  local wk = require("which-key")
  for _,v in ipairs(M.defaults) do
    wk.register(v.mapping, v.opts or DefaultOpts{mode = v.mode or "n" })
  end
end

--
-- -- navigation
-- ["<A-Up>"] = "<C-\\><C-N><C-w>k",
-- ["<A-Down>"] = "<C-\\><C-N><C-w>j",
-- ["<A-Left>"] = "<C-\\><C-N><C-w>h",
-- ["<A-Right>"] = "<C-\\><C-N><C-w>l",
-- },
--
--
-- term_mode = {
-- -- Terminal window navigation
-- ["<C-h>"] = "<C-\\><C-N><C-w>h",
-- ["<C-j>"] = "<C-\\><C-N><C-w>j",
-- ["<C-k>"] = "<C-\\><C-N><C-w>k",
-- ["<C-l>"] = "<C-\\><C-N><C-w>l",
-- },
--
-- -- ["p"] = ""0p",
-- -- ["P"] = ""0P",
--
-- command_mode = {
-- -- navigate tab completion with <c-j> and <c-k>
-- -- runs conditionally
-- ["<C-j>"] = { "pumvisible() ? "\\<C-n>" <CMD> "\\<C-j>"", { expr = true, noremap = true } },
-- ["<C-k>"] = { "pumvisible() ? "\\<C-p>" <CMD> "\\<C-k>"", { expr = true, noremap = true } },
-- },
return M
