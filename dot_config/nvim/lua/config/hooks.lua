local M = {}

local defaults = {
	{
		"TextYankPost",
		{
			desc = "Highlight text on yank",
			group = "general_settings",
			pattern = "*",
			callback = function()
				vim.highlight.on_yank { higroup = "Search", timeout = 100 }
			end,
		},
	},
	-- {
	-- 	"FileType",
	-- 	{
	-- 		desc = "Hide the debugger REPL from buffer listing",
	-- 		group = "hide_dap_repl",
	-- 		pattern = "dap-repl",
	-- 		command = "set nobuflisted",
	-- 	},
	-- },
	{
		"FileType",
		{
			desc = "Fix gf functionality inside .lua files",
			group = "filetype_settings",
			pattern = { "lua" },
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
			desc = "Hide certain buffers from listing",
			group = "set_nobuflisted_UI_buffers",
			pattern = {
				"qf",
				"help",
				"man",
				"floaterm",
				"toggleterm",
				"mason",
				"Trouble",
				"alpha",
				"aerial",
				"NvimTree",
				-- "terminal"
			},
			callback = function()
				vim.opt_local.buflisted = false
				vim.opt_local.foldenable = false
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
	-- {
	-- 	-- executed on new directory opened
	-- 	-- taken from AstroNvim
	-- 	"BufEnter",
	-- 	{
	-- 		group = "dir_opened",
	-- 		nested = true,
	-- 		callback = function(args)
	-- 			local bufname = vim.api.nvim_buf_get_name(args.buf)
	-- 			if require("utils").is_directory(bufname) then
	-- 				vim.api.nvim_del_augroup_by_name "dir_opened"
	-- 				vim.cmd "do User DirOpened"
	-- 				vim.api.nvim_exec_autocmds(args.event, { buffer = args.buf, data = args.data })
	-- 			end
	-- 		end,
	-- 	},
	-- },
	-- {
	-- 	-- executed when a file is opened
	-- 	-- taken from AstroNvim
	-- 	{ "BufReadPre" },
	-- 	{
	-- 		group = "user_file_pre",
	-- 		nested = true,
	-- 		callback = function(args)
	-- 			local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
	-- 			local bufname = vim.api.nvim_buf_get_name(args.buf)
	-- 			if not (bufname == "" or buftype == "nofile") then
	-- 				vim.api.nvim_del_augroup_by_name "user_file_pre"
	-- 				vim.cmd "do User FilePre"
	-- 			end
	-- 		end,
	-- 	},
	-- },
	-- {
	-- 	-- executed when a file is opened
	-- 	-- taken from AstroNvim
	-- 	{ "BufReadPost", "BufNewFile" },
	-- 	{
	-- 		group = "user_file_post",
	-- 		nested = true,
	-- 		callback = function(args)
	-- 			local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
	-- 			local bufname = vim.api.nvim_buf_get_name(args.buf)
	-- 			if not (bufname == "" or buftype == "nofile") then
	-- 				vim.api.nvim_del_augroup_by_name "user_file_post"
	-- 				vim.cmd "do User FilePost"
	-- 			end
	-- 		end,
	-- 	},
	-- },
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
				local numbufs = #vim.tbl_filter(
					function(b)
						if 1 ~= vim.fn.buflisted(b) then
							return false
						end
						if not vim.api.nvim_buf_is_loaded(b) then
							return false
						end
						return true
					end,
					vim.api.nvim_list_bufs()
				)

				if numbufs == 1 then
					local fallback_name = vim.api.nvim_buf_get_name(args.buf)
					local fallback_ft = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
					local fallback_on_empty = fallback_name == "" and fallback_ft == ""
					if fallback_on_empty then
						vim.cmd("Alpha")
						vim.cmd(args.buf .. "bwipeout")
					end
				end
			end
		}
	},
}
--- Load the default set of autogroups and autocommands.
function M.load_defaults()
	require("autocmds").define_autocmds(defaults)
end

return M
