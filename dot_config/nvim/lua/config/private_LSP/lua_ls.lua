local M = {}

M.config = {
	on_attach = function(client)
		local cwd = client.workspace_folders
		if not cwd then return end
		local path = cwd[1].name
		if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
			return
		end
		local vim_dirs = {
			vim.fn.stdpath('config'),
			'/home/abhinav/projects/software/nvim_plugins',
			vim.fn.stdpath('data')
		}
		if vim.iter(vim_dirs):any(
			function(val)
				return path:find(val) and true or false
			end
		) then
			client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT'
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					library = {
						vim.env.VIMRUNTIME,
						-- Depending on the usage, you might want to add additional paths here.
						"${3rd}/luv/library"
						-- "${3rd}/busted/library",
					}
					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
					-- library = vim.api.nvim_get_runtime_file("", true)
				}
			})
		end
	end,
	settings = {
		Lua = {
			hint = {
				enable = true
			},
			workspace = {
				checkThirdParty = false,
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	},
}

return M
