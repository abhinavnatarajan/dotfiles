local M = {}

--- Create autocommand groups based on the passed definitions
--- Also creates the augroup automatically if it doesn't exist
---@param definitions table contains a tuple of event, opts, see `:h nvim_create_autocmd`
function M.define_autocmds(definitions)
  for _, entry in ipairs(definitions) do
    local event = entry[1]
    local opts = entry[2]
    if type(opts.group) == "string" and opts.group ~= "" then
      local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
      if not exists then
        vim.api.nvim_create_augroup(opts.group, {})
      end
    end
    vim.api.nvim_create_autocmd(event, opts)
  end
end

--- Clean autocommand in a group if it exists
--- This is safer than trying to delete the augroup itself
---@param name string the augroup name
function M.clear_augroup(name)
  -- defer the function in case the autocommand is still in-use
  vim.schedule(function()
    pcall(function()
      vim.api.nvim_clear_autocmds { group = name }
    end)
  end)
end

--[[ function M:reload()
  vim.schedule(function()
    reload("lvim.utils.hooks").run_pre_reload()

    M:load()

    reload("lvim.core.autocmds").configure_format_on_save()

    local plugins = reload "lvim.plugins"
    local plugin_loader = reload "lvim.plugin-loader"

    plugin_loader.reload { plugins, lvim.plugins }
    reload("lvim.core.theme").setup()
    reload("lvim.utils.hooks").run_post_reload()
  end)
end

function M.enable_reload_config_on_save()
  -- autocmds require forward slashes (even on windows)
  local pattern = get_config_dir():gsub("\\", "/") .. "/*.lua"

  vim.api.nvim_create_augroup("reload_config_on_save", {})
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = "reload_config_on_save",
    pattern = pattern,
    desc = "Reload settings on making changes to any config file",
    callback = function()
      require("lvim.config"):reload()
    end,
  })
end ]]

local defaults = {
  {
    "TextYankPost",
    {
      group = "general_settings",
      pattern = "*",
      desc = "Highlight text on yank",
      callback = function()
        vim.highlight.on_yank { higroup = "Search", timeout = 100 }
      end,
    },
  },
  {
    "FileType",
    {
      group = "hide_dap_repl",
      pattern = "dap-repl",
      command = "set nobuflisted",
    },
  },
  {
    "FileType",
    {
      group = "filetype_settings",
      pattern = { "lua" },
      desc = "fix gf functionality inside .lua files",
      callback = function()
        -- credit: https://github.com/sam4llis/nvim-lua-gf
        vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
        vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
        vim.opt_local.suffixesadd:prepend ".lua"
        vim.opt_local.suffixesadd:prepend "init.lua"

        for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
          vim.opt_local.path:append(path .. "/lua")
        end
      end,
    },
  },
  {
    "FileType",
    {
      group = "buffer_mappings",
      pattern = {
        "qf",
        "help",
        "man",
        "floaterm",
        "lspinfo",
        "lsp-installer",
        "null-ls-info",
        "mason",
        "Trouble",
      },
      callback = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", { desc = "Close window", buffer = true })
        vim.opt_local.buflisted = false
        vim.opt_local.wrap = true
        vim.opt_local.wrap = true
        vim.opt_local.whichwrap = '<>[]lh'
        vim.opt_local.breakindent = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakat = " ^I!@*-+;,/?"
      end,
    },
  },
  {
    "VimResized",
    {
      group = "auto_resize",
      pattern = "*",
      command = "tabdo wincmd =",
    },
  },
  {
    "FileType",
    {
      group = "filetype_settings",
      pattern = "alpha",
      callback = function()
        vim.opt_local.buflisted = false
        vim.wo.foldenable = false
      end,
    },
  },
  {
    "ColorScheme",
    {
      group = "colorscheme",
      callback = function()
        --[[ if lvim.builtin.breadcrumbs.active then
            require("lvim.core.breadcrumbs").get_winbar()
          end ]]
        local statusline_hl = vim.api.nvim_get_hl(0, {name="StatusLine", link=true})
        local cursorline_hl = vim.api.nvim_get_hl(0, {name="CursorLine", link=true})
        local normal_hl = vim.api.nvim_get_hl(0, {name="Normal", link=true})
        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
        vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
        vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })
        vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
        vim.api.nvim_set_hl(0, "SLCopilot", { fg = "#6CC644", bg = statusline_hl.background })
        vim.api.nvim_set_hl(0, "SLGitIcon", { fg = "#E8AB53", bg = cursorline_hl.background })
        vim.api.nvim_set_hl(0, "SLBranchName", { fg = normal_hl.foreground, bg = cursorline_hl.background })
        vim.api.nvim_set_hl(0, "SLSeparator", { fg = cursorline_hl.background, bg = statusline_hl.background })
      end,
    },
  },
  {
    -- executed on new directory opened
    -- taken from AstroNvim
    "BufEnter",
    {
      group = "dir_opened",
      nested = true,
      callback = function(args)
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        if M.is_directory(bufname) then
          vim.api.nvim_del_augroup_by_name "dir_opened"
          vim.cmd "do User DirOpened"
          vim.api.nvim_exec_autocmds(args.event, { buffer = args.buf, data = args.data })
        end
      end,
    },
  },
  {
    -- executed when a file is opened
    -- taken from AstroNvim
    { "BufRead", "BufWinEnter", "BufNewFile" },
    {
      group = "file_opened",
      nested = true,
      callback = function(args)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
        if not (vim.fn.expand "%" == "" or buftype == "nofile") then
          vim.api.nvim_del_augroup_by_name "file_opened"
          vim.cmd "do User FileOpened"
        end
      end,
    },
  },
  {
    -- open dashboard when all writable buffers are closed
    "User", --bufdelete.nvim triggers a User autocommand BDeletePost <buffer>
    {
      group = "fallback_to_dashboard",
      pattern = "BDeletePost*",
      callback = function(args)
        -- args is a table, args.buf is the currently effective buffer
        -- see nvim_create_autocmd()

        -- check if this is the last buffer
        local buflist = vim.api.nvim_list_bufs()
        local numbufs = 0
        for buf in pairs(buflist) do
          if vim.api.nvim_buf_is_loaded(buf) then
            numbufs = numbufs + 1
          end
        end
        if numbufs == 1 then
          local fallback_name = vim.api.nvim_buf_get_name(args.buf)
          local fallback_ft = vim.api.nvim_buf_get_option(args.buf, "filetype")
          local fallback_on_empty = fallback_name == "" and fallback_ft == ""
          if fallback_on_empty then
            vim.cmd('Alpha')
            vim.cmd(args.buf .. "bwipeout")
          end
        end
      end
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
  {
    "User", 
    {
      group = "save_session_notify",
      pattern = "SessionSavePost",
      callback = function() vim.notify("Saved session for workspace\n" .. vim.fn.getcwd()) end
    },
  },
  {
    -- hovering diagnostics messages
    "CursorHold",
    {
      group = "diagnostics_hover",
      callback = function(args)
        vim.diagnostic.open_float(nil, {
          bufnr = args.buf,
        })
      end
    },
  },
  {
    -- LSp keymaps
    "LspAttach",
    {
      group = "lsp_keybindings",
      callback = function(args)
        local icons = require("icons")
        local opts = {buffer = args.buf}
        local bufmap = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, {desc = desc})) end
        local client_capabilities = vim.lsp.get_client_by_id(args.data.client_id).server_capabilities

        -- if client_capabilities.hoverProvider then
        --   bufmap('n', 'K', vim.lsp.buf.hover, "Hover symbol info")
        -- end
        if client_capabilities.renameProvider then
          bufmap('n', '<F51>', vim.lsp.buf.rename, icons.syntax.Object .. " Rename symbol")
        end
        if client_capabilities.definitionProvider then
          bufmap('n', 'gd', vim.lsp.buf.definition, "Go to definition")
        end
        if client_capabilities.declarationProvider then
          bufmap('n', 'gD', vim.lsp.buf.declaration, "Go to declaration")
        end
        if client_capabilities.signatureHelpProvider then
          bufmap('n', 'gs', vim.lsp.buf.signature_help, "Go to signature")
        end
        if client_capabilities.codeActionProvider then
          bufmap('n', '<F4>', vim.lsp.buf.code_action, "Code actions")
          bufmap('x', '<F4>', vim.lsp.buf.code_action, "Code actions")
        end
        bufmap('n', '[d', vim.diagnostic.goto_prev, "Previous diagnostic")
        bufmap('n', ']d', vim.diagnostic.goto_next, "Next diagnostic")
      end
    }
  }
}
--- Load the default set of autogroups and autocommands.
function M.load_defaults()
  M.define_autocmds(defaults)
end

function M.is_directory(name)
  local stat = vim.loop.fs_stat(name)
  return stat and stat.type == 'directory' or false
end

function M.is_file(name)
  local stat = vim.loop.fs_stat(name)
  return stat and stat.type == 'file' or false
end


return M
