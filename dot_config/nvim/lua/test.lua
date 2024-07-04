local ts = vim.treesitter
local M = {}

M.comment_parsers = {
	comment = true,
	jsdoc = true,
	phpdoc = true,
}

M.avoid_force_reparsing = {
	yaml = true,
}

local function getline(lnum)
	return vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
end

---@param lnum integer
---@return integer
local function get_indentcols_at_line(lnum)
	local _, indentcols = getline(lnum):find "^%s*"
	return indentcols or 0
end

---@param root TSNode
---@param lnum integer
---@param col? integer
---@return TSNode
local function get_first_node_at_line(root, lnum, col)
	col = col or get_indentcols_at_line(lnum)
	return root:descendant_for_range(lnum - 1, col, lnum - 1, col + 1)
end

---@param root TSNode
---@param lnum integer
---@param col? integer
---@return TSNode
local function get_last_node_at_line(root, lnum, col)
	col = col or (#getline(lnum) - 1)
	return root:descendant_for_range(lnum - 1, col, lnum - 1, col + 1)
end

---@param node TSNode
---@return number
local function node_length(node)
	local _, _, start_byte = node:start()
	local _, _, end_byte = node:end_()
	return end_byte - start_byte
end

M.get_node = function(lnum, col)
	local bufnr = vim.api.nvim_get_current_buf()
	local parsers = require "nvim-treesitter.parsers"
	local parser = parsers.get_parser(bufnr)
	if not parser or not lnum then
		return -1
	end

	--TODO(clason): replace when dropping Nvim 0.8 compat
	local root_lang = parsers.get_buf_lang(bufnr)

	-- some languages like Python will actually have worse results when re-parsing at opened new line
	if not M.avoid_force_reparsing[root_lang] then
		-- Reparse in case we got triggered by ":h indentkeys"
		parser:parse { vim.fn.line "w0" - 1, vim.fn.line "w$" }
	end

	-- Get language tree with smallest range around node that's not a comment parser
	local root, lang_tree ---@type TSNode, LanguageTree
	parser:for_each_tree(function(tstree, tree)
		if not tstree or M.comment_parsers[tree:lang()] then
			return
		end
		local local_root = tstree:root()
		if ts.is_in_node_range(local_root, lnum - 1, 0) then
			if not root or node_length(root) >= node_length(local_root) then
				root = local_root
				lang_tree = tree
			end
		end
	end)

	-- Not likely, but just in case...
	if not root then
		return 0
	end

	local node = get_first_node_at_line(root, lnum, col)
	local start_row, start_col, start_byte, end_row, end_col, end_byte = node:range({ include_bytes = true })
	local result = {
		name = node:type(),
		start_col = start_col,
		end_col = end_col,
		start_row = start_row,
		end_row = end_row,
		start_byte = start_byte,
		end_byte = end_byte,
	}
	return result
end

return M
