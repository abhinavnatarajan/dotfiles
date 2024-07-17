local lazy = {}

function lazy.require(modname)
	return setmetatable({}, {
		__index = function(_, key)
			return require(modname)[key]
		end,
		__newindex = function(_, key, value)
			require(modname)[key] = value
		end,
	})
end

return lazy
