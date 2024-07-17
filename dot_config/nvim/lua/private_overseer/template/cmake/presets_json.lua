-- CMake
return {
	generator = function(_, cb)
		local cmake_presets = {}
		if vim.fn.filereadable('CMakePresets.json') == 1 then
			cmake_presets = vim.json.decode(
				vim.system(
					{ 'cat', 'CMakePresets.json' },
					{ text = true }
				):wait().stdout,
				{ luanil = { object = true, array = true } }
			)
		end
		local configure_presets = cmake_presets.configurePresets or {}
		local build_presets = cmake_presets.buildPresets or {}
		local test_presets = cmake_presets.testPresets or {}
		local package_presets = cmake_presets.packagePresets or {}
		local workflow_presets = cmake_presets.workflowPresets or {}
		local preset_list = {
			{ t = workflow_presets,  cmd = "cmake --workflow", prefix = "(CMake Workflow)" },
			{ t = configure_presets, cmd = "cmake",            prefix = "(CMake)" },
			{ t = build_presets,     cmd = "cmake --build",    prefix = "(CMake build)" },
			{ t = test_presets,      cmd = "ctest",            prefix = "(CTest)" },
			{ t = package_presets,   cmd = "cpack",            prefix = "(CPack)" },
		}
		local templates = {}
		local i = 1
		for _, preset_type in ipairs(preset_list) do
			for _, preset in ipairs(preset_type.t) do
				preset.displayName = preset.displayName or preset.name
				table.insert(templates, {
					name = table.concat({ preset_type.prefix, preset.displayName }, " "),
					builder = function()
						return {
							name = table.concat({ preset_type.prefix, preset.displayName }, " "),
							cmd = table.concat({ preset_type.cmd, "--preset", preset.name }, " "),
							components = {
								{
									"parse_into_quickfix",
									open_on_exit = true,
									open_on_match = false,
								},
								"default"
							},
						}
					end,
					priority = i,
				})
				i = i + 1
			end
		end

		cb(templates)
	end,
	cache_key = function(opts)
		return vim.fs.joinpath(opts.dir, 'CMakePresets.json')
	end,
	condition = {
		callback = function(search)
			if not vim.fn.filereadable(vim.fs.joinpath(search.dir, 'CMakePresets.json')) then
				return false, "CMakePresets.json not found"
			end
			if not vim.fn.executable("cmake") then
				return false, 'Command "cmake" not found'
			end
			return true
		end,
	},
}
