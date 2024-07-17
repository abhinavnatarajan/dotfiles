local C = {
	ComponentList = {},
}

---@class Component
---@field is_open function(): boolean
---@field open function
---@field close function() : any
local Component = {}
Component.__index = Component

function Component:toggle(...)
	if self.is_open() then
		self.close()
	else
		C.hide_all()
		self.open(unpack({ ... }))
	end
end

function Component:show(...)
	if self.is_open() then
		return
	end
	C.hide_all()
	self.open(unpack({ ... }))
end

function Component:new(obj)
	setmetatable(obj, self)
	return obj
end

function C.hide_all()
	for _, c in pairs(C.ComponentList) do
		if c.is_open() then
			c.close()
		end
	end
end

---@param name string
---@param opts table
function C.register_component(name, opts)
	C.ComponentList[name] = Component:new(opts)
	return C.ComponentList[name]
end

return C
