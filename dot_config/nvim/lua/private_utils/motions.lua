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
		{ pattern = "^%w", offset_from_start = 0, offset_from_end = 0 },
	},
	wordEnding = {
		{ pattern = "%a%A", offset_from_start = 0, offset_from_end = 1 },
		{ pattern = "%l%u", offset_from_start = 0, offset_from_end = 1 },
		{ pattern = "%d%D", offset_from_start = 1, offset_from_end = 0 },
		{ pattern = "%w$", offset_from_start = 0, offset_from_end = 0 },
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

local opfunc

function M.setup(opts)
	opts = opts or {}
	options = vim.tbl_deep_extend("keep", opts, defaultOptions)
end

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
		vim.notify(msg, vim.log.levels.ERROR, { title = "Motions" })
		return
	end
	if not options then
		M.setup()
	end
	opts = vim.tbl_deep_extend("keep", opts or {}, options[key])

	local mode = vim.api.nvim_get_mode().mode
	if mode == "n" then -- normal mode
		if opts.dotRepeatable then
			opfunc = function()
				M._motion(key)
			end
			vim.go.operatorfunc = "v:lua.require'utils.motions'.opfunc"
			vim.cmd.normal("g@l")
			return
		end
	elseif mode == "no" then -- operator pending mode
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

-- findNextMatch searches for the next match of a pattern in a line starting from
-- initPos. If the pattern starts with a caret (^), then it will only match at
-- the beginning of the line. If no match is found, it will return nil.
---@param line string the line to search
---@param initPos number the position to start searching from
---@param pattern string the pattern to search for
---@param patternOffset number the offset from the start of the match to the desired position
---@return number|nil,number|nil # star and end positions of the match, or nil
function M.findNextMatch(line, initPos, pattern, patternOffset)
	if pattern:find("^%^") and initPos > 0 then
		return nil
	end
	local i = initPos
	local start, finish = nil, nil
	while i <= #line do
		start, finish = line:find(pattern, i)
		if not start then
			break
		end
		if start + patternOffset > initPos then
			return start, finish
		end
		i = finish + 1
	end
	return nil
end

---findPreviousMatch searches for the previous match of a pattern in a line starting from
---initPos. If the pattern ends with a dollar sign ($), then it will only match at
---the end of the line. If no match is found, it will return nil.
---@param line string the line to search
---@param initPos number the position to start searching backward from
---@param pattern string the pattern to search for
---@param patternOffset number the offset from the end of the match to the desired position
---@return number|nil,number|nil # start and end positions of the match, or nil
function M.findPrevMatch(line, initPos, pattern, patternOffset)
	if pattern:find("%$$") and initPos <= #line then
		return nil
	end
	local i = initPos
	local start, finish = nil, nil
	while i > 0 do
		start, finish = line:sub(1, i):find(".*" .. pattern)
		if not start then
			break
		end
		vim.notify(vim.inspect({ start, finish }), vim.log.levels.INFO)
		if finish - patternOffset < initPos then
			return start, finish
		end
		-- Continue searching to find the closest match to initPos
		i = finish - 1
	end
	return nil
end

function M.getNextPosition(line, initPos, pats)
	if initPos == #line then
		-- already at end of line
		return nil
	end
	local res = #line + 1
	for _, p in ipairs(pats) do
		local pattern, patternOffset = p.pattern, p.offset_from_start
		local matchStart, _ = M.findNextMatch(line, initPos, pattern, patternOffset)
		if matchStart and matchStart + patternOffset < res then
			res = matchStart + patternOffset
		end
	end
	return res <= #line and res or nil
end

function M.getPrevPosition(line, initPos, pats)
	if initPos == 1 then
		-- already at end of line
		return nil
	end
	local res = 0
	for _, p in ipairs(pats) do
		local pattern, patternOffset = p.pattern, p.offset_from_end
		local _, finish = M.findPrevMatch(line, initPos, pattern, patternOffset)
		if finish and finish - patternOffset > res then
			res = finish - patternOffset
		end
	end
	return res > 0 and res or nil
end

setmetatable(M, {
	__index = function(_, key)
		if key == "opfunc" then
			return opfunc
		end
	end,
})

return M
