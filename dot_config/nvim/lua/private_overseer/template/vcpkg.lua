return {
	name = "(Vcpkg) Install/update dependencies",
	params = {
		install_root = {
			type = "string",
			name = "Installation root directory",
			optional = true,
			default = vim.fs.joinpath(vim.fs.root(vim.fn.getcwd(), 'vcpkg.json'), 'build', 'vcpkg_installed')
		}
	},
	builder = function(params)
		return {
			cmd = {
				'vcpkg',
				'install',
				'--x-install-root',
				params.install_root
			},
		}
	end,
	condition = {
		callback = function(search)
			if not vim.fs.root(search.dir, 'vcpkg.json') then
				return false, 'vcpkg.json not found'
			end
			if not vim.fn.executable('vcpkg') then
				return false, 'Command "vcpkg" not found'
			end
			return true
		end
	}
}
