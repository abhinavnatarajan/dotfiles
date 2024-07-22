local M = {}

local motionKeys = { "w", "e", "b", "ge" }
local forwardKeys = { "w", "e" }
local wordBeginKeys = { "w", "b" }
local patterns = {
	-- %a = alphabet, %d = digitl, %w = alphanumeric, %l = lowercase %u = uppercase
	-- ^ = start of line, $ = end of line
	-- capitalised versions are complements
	wordBeginning = {
		{ pattern = "%A%a", offset_from_start = 1, offset_from_end = 0 },
		{ pattern = "%l%u", offset_from_start = 1, offset_from_end = 0 },
		{ pattern = "%D%d", offset_from_start = 1, offset_from_end = 0 },
		{ pattern = "^%w",  offset_from_start = 0, offset_from_end = 0 },
	},
	wordEnding = {
		{ pattern = "%a%A", offset_from_start = 0, offset_from_end = 1 },
		{ pattern = "%l%u", offset_from_start = 0, offset_from_end = 1 },
		{ pattern = "%d%D", offset_from_start = 0, offset_from_end = 0 },
		{ pattern = "%w$",  offset_from_start = 0, offset_from_end = 0 },
	},
}
local defaultOptions = {
	w = {
		inclusive = false,
		dotRepeatable = true,
	},
	b = {
		inclusive = false,
		dotRepeatable = true,
	},
	e = {
		inclusive = true,
		dotRepeatable = true,
	},
	ge = {
		inclusive = true,
		dotRepeatable = true,
	},
}
local options

---@param lnum number 1-indexed
---@nodiscard
---@return string
local function getline(lnum)
	return vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]
end

---@param key "w"|"e"|"b"|"ge" the motion to perform
function M.motion(key, opts)
	-- GUARD validate motion parameter
	if not vim.list_contains(motionKeys, key) then
		local msg = "Invalid key: " .. key .. "\nOnly w, e, b, and ge are supported."
		-- TODO: title of the error message
		vim.notify(msg, vim.log.levels.ERROR, { title = "Motions" })
		return
	end
	if not options then
		M.setup()
	end
	opts = vim.tbl_deep_extend("keep", opts or {}, options[key])

	local mode = vim.api.nvim_get_mode().mode
	if mode == "n" and opts.dotRepeatable then
		M.opfunc = function()
			M._motion(key)
		end
		vim.go.opfunc = "v:lua.require'utils.motions'.opfunc"
		vim.cmd.normal(vim.v.count1 .. "g@l")
		return
	end
	if mode == "no" then -- operator pending mode
		if opts.inclusive then
			vim.cmd.normal("v") -- force charwise inclusive motion
		end
	end
	M._motion(key)
end

function M._motion(key)
	local forward = vim.list_contains(forwardKeys, key)
	local pats = vim.list_contains(wordBeginKeys, key) and patterns.wordBeginning or patterns.wordEnding
	local startPos = vim.api.nvim_win_get_cursor(0) -- (1,0)-indexed
	local row, col = unpack(startPos)
	local lastRow = vim.api.nvim_buf_line_count(0)
	local line = getline(row)
	local offset = col + 1 -- lua strings are 1-indexed
	for _ = 1, vim.v.count1, 1 do
		-- looping through rows (if next location not found in line)
		while true do
			local result
			if forward then
				result = M.getNextPosition(line, offset, pats)
			else
				result = M.getPrevPosition(line, offset, pats)
			end
			if result then
				offset = result
				break
			end

			row = forward and row + 1 or row - 1
			if row > lastRow or row < 1 then
				return
			end
			line = getline(row)
			offset = forward and 0 or #line + 1
		end
	end

	col = offset - 1
	--
	-- respect `opt.foldopen = "hor"`
	-- local shouldOpenFold = vim.tbl_contains(vim.opt_local.foldopen:get(), "hor")
	-- if mode == "n" and shouldOpenFold then normal("zv") end

	vim.api.nvim_win_set_cursor(0, { row, col })
end

M.textObjects = {}

function M.textObjects.charwiseLine(key, mode)
	local operation = mode == "o" and vim.v.operator or "v"
	local start = key == "i" and "^" or "0"
	local finish = key == "i" and "g_" or "$"
	return "<Esc>" .. start .. operation .. finish
end

function M.textObjects.word(key, mode)
	if key ~= "i" and key ~= "a" then
		-- TODO: title of the error message
		vim.notify(
			"Invalid key: " .. key .. "\nOnly i and a are supported.",
			vim.log.levels.ERROR,
			{ title = "TextObject" }
		)
		return
	end

	-- get the end position of the text object
	local startPos = vim.api.nvim_win_get_cursor(0) -- (1,0)-indexed
	local row, col = unpack(startPos)
	local lastRow = vim.api.nvim_buf_line_count(0)
	local line = getline(row)
	local offset = col + 1 -- lua strings are 1-indexed
	local pats = patterns.wordEnding
	while true do
		local result = M.getNextPosition(line, offset, pats, 0)
		if result then
			offset = result
			break
		end
		row = row + 1
		if row > lastRow then
			row = lastRow
			offset = #line
			break
		end
		line = getline(row)
		offset = 0
	end
	local endPos = { row, offset - 1 } -- (1,0)-indexed
	if key == "a" then
		local tempOffset = offset
		pats = patterns.wordBeginning
		local result = M.getNextPosition(line, offset, pats, 0)
		local moveBack = false
		if result then
			offset = result
			moveBack = true
		else
			offset = #line
		end
		if moveBack then -- need to move back by one character
			offset = offset - 1
		end
		endPos = { row, offset - 1 } -- (1,0)-indexed
		offset = tempOffset
	end

	-- get the start position of the textobject
	pats = patterns.wordBeginning
	while true do
		local result = M.getPrevPosition(line, offset, pats, 0)
		if result then
			offset = result
			break
		end
		row = row - 1
		if row < 1 then
			row = 1
			offset = 1
			break
		end
		line = getline(row)
		offset = 0
	end
	local wordStartPos = { row, offset - 1 } -- (1,0)-indexed
	if wordStartPos[1] < startPos[1] or (wordStartPos[1] == startPos[1] and wordStartPos[2] <= startPos[2]) then
		startPos = wordStartPos
	end


	-- build up the expression to execute
	local operation
	local inclusive = key == "i"
	if mode == "o" then
		operation = vim.v.operator .. (inclusive and "v" or "")
	else
		-- visual mode
		operation = vim.fn.mode() -- visual mode
		-- if not inclusive then
		-- 	endPos[2] = endPos[2] - 1
		-- end
	end
	return "<Esc><Cmd>lua vim.api.nvim_win_set_cursor(0, {" .. startPos[1] .. ", " .. startPos[2] .. "})<CR>"
			.. operation
			.. "<Cmd>lua vim.api.nvim_win_set_cursor(0, {" .. endPos[1] .. ", " .. endPos[2] .. "})<CR>"
end

-- findNextMatch searches for the next match of a pattern in a line starting from
-- initPos. If the pattern starts with a caret (^), then it will only match at
-- the beginning of the line. If no match is found, it will return nil.
---@param line string the line to search
---@param initPos number the position to start searching from
---@param pattern string the pattern to search for
---@return number|nil,number|nil # star and end positions of the match, or nil
function M.findNextMatch(line, pattern, initPos)
	if pattern:find("^%^") and initPos > 0 then
		return nil
	end
	return line:find(pattern, initPos)
end

---findPreviousMatch searches for the previous match of a pattern in a line starting from
---initPos. If the pattern ends with a dollar sign ($), then it will only match at
---the end of the line. If no match is found, it will return nil.
---@param line string the line to search
---@param initPos number the position to start searching backward from
---@param pattern string the pattern to search for
---@return number|nil,number|nil # start and end positions of the match, or nil
function M.findPrevMatch(line, pattern, initPos)
	if pattern:find("%$$") and initPos <= #line then
		return nil
	end
	if pattern:sub(1, 1) ~= "^" then
		-- if the pattern does not begin the line,
		-- we search for the last match of the pattern
		-- this allows us to implement a crude 'rfind'
		pattern = ".*" .. pattern
	end
	return line:sub(1, initPos):find(pattern)
end

function M.getNextPosition(line, initPos, pats, mustMove)
	mustMove = mustMove or 1
	if initPos == #line and mustMove > 0 then
		-- already at end of line
		return nil
	end
	local res = #line + 1
	for _, p in ipairs(pats) do
		local pattern, patternOffset = p.pattern, p.offset_from_start
		local start
		for i = initPos, #line do
			start, _ = M.findNextMatch(line, pattern, i)
			if start and start + patternOffset >= initPos + mustMove then
				break
			end
		end
		if start and start + patternOffset < res then
			res = start + patternOffset
		end
	end
	return res <= #line and res or nil
end

function M.getPrevPosition(line, initPos, pats, mustMove)
	mustMove = mustMove or 1
	if initPos == 1 and mustMove > 0 then
		-- already at end of line
		return nil
	end
	local res = 0
	for _, p in ipairs(pats) do
		local pattern, patternOffset = p.pattern, p.offset_from_end
		local finish
		for i = initPos, 1, -1 do
			_, finish = M.findPrevMatch(line, pattern, i)
			if finish and finish - patternOffset <= initPos - mustMove then
				break
			end
		end
		if finish and finish - patternOffset > res then
			res = finish - patternOffset
		end
	end
	return res > 0 and res or nil
end

function M.setup(opts)
	opts = opts or {}
	options = vim.tbl_deep_extend("keep", opts, defaultOptions)
	vim.keymap.set(
		"o",
		"<Plug>(textobject-iw)",
		function()
			return M.textObjects.word("i", "o")
		end,
		{ expr = true }
	)
	vim.keymap.set(
		"x",
		"<Plug>(textobject-iw)",
		function()
			return M.textObjects.word("i", "x")
		end,
		{ expr = true }
	)
	vim.keymap.set(
		"o",
		"<Plug>(textobject-aw)",
		function()
			return M.textObjects.word("a", "o")
		end,
		{ expr = true }
	)
	vim.keymap.set(
		"x",
		"<Plug>(textobject-aw)",
		function()
			return M.textObjects.word("a", "x")
		end,
		{ expr = true }
	)
	vim.keymap.set(
		"o",
		"<Plug>(textobject-il)",
		function()
			return M.textObjects.charwiseLine("i", "o")
		end,
		{ expr = true }
	)
	vim.keymap.set(
		"x",
		"<Plug>(textobject-il)",
		function()
			return M.textObjects.charwiseLine("i", "x")
		end,
		{ expr = true }
	)
	vim.keymap.set(
		"o",
		"<Plug>(textobject-al)",
		function()
			return M.textObjects.charwiseLine("a", "o")
		end,
		{ expr = true }
	)
	vim.keymap.set(
		"x",
		"<Plug>(textobject-al)",
		function()
			return M.textObjects.charwiseLine("a", "x")
		end,
		{ expr = true }
	)
end

return M
