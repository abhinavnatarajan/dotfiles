local M = {}

---makes a table into a class with a constructor
---@param tbl table
---@return table
---@usage local MyClass = M.prototype (MyClass)
function M.prototype(tbl)
  return setmetatable(tbl,
    {__call = function(_, init)
      return setmetatable(init or {}, {__index = tbl})
    end
    }
  )
end

---asynchronous input prompt that can be called inside a coroutine
---@param opts table see :h vim.ui.input()
---@return string the input from the user
M.async_get_input = function(opts)
	local co, _ = assert(coroutine.running(), "Function must run in a coroutine.")
	vim.ui.input(opts, function(input) coroutine.resume(co, input) end)
	local input = coroutine.yield()
	return input
end

---asunchronous selection prompt that can be called inside a coroutine
---@param items table the items to choose from
---@param opts table see :h vim.ui.select()
---@return string the selected item
M.async_get_selection = function(items, opts)
	local co, _ = assert(coroutine.running(), "Function must run in a coroutine.")
	vim.ui.select(items, opts, function(selection) coroutine.resume(co, selection) end)
	local selection = coroutine.yield()
	vim.notify("here")
	return selection
end

return M
