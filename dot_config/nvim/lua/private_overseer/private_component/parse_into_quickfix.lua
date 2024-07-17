---@param self table The component
---@param height nil|integer
---@return boolean True if the quickfix window was opened
local function copen(self, height)
	-- Only open the quickfix once. If the user closes it, we don't want to re-open.
	if self.qf_opened then
		return false
	end
	local open_cmd = "botright copen"
	if height then
		open_cmd = string.format("%s %d", open_cmd, height)
	end
	vim.cmd(open_cmd)
	local cur_qf = vim.fn.getqflist({ id = 0 })
	self.qf_opened = true
	return cur_qf == self.qf_id
end

local comp_def = {
	desc = "Parse task output and set the quickfix list",
	params = {
		errorformat = {
			desc = "See :help errorformat",
			type = "string",
			optional = true,
			default_from_task = true,
		},
		open_on_exit = {
			desc = "Open the quickfix list (if non-empty) on exit",
			type = "boolean",
			default = true,
		},
		open_on_match = {
			desc = "Open the quickfix when the errorformat finds a match",
			type = "boolean",
			default = false,
		},
		open_height = {
			desc = "The height of the quickfix when opened",
			type = "integer",
			optional = true,
			validate = function(v)
				return v > 0
			end,
		},
		relative_file_root = {
			desc = "Relative filepaths will be joined to this root (instead of task cwd)",
			optional = true,
			default_from_task = true,
		},
		set_diagnostics = {
			desc = "Add the matching items to vim.diagnostics",
			type = "boolean",
			default = false,
		},
	},
	constructor = function(params)
		local util = require("overseer.util")
		local comp = {
			qf_id = 0,
			qf_opened = false,
			on_reset = function(self, _)
				self.qf_id = 0
				self.qf_opened = false
				self.has_items = false
			end,
			on_exit = function(self, _, _)
				if params.open_on_exit and self.has_items then
					copen(self, params.open_height)
				end
			end,
			on_output_lines = function(self, task, lines)
				local cur_qf = vim.fn.getqflist({ context = 0, id = self.qf_id })
				local action = " "
				if cur_qf.context == task.id then
					-- qf_id is 0 after a restart. If we're restarting; replace the contents of the list.
					-- Otherwise append.
					action = self.qf_id == 0 and "r" or "a"
				end
				-- Run this in the context of the task cwd so that relative filenames are parsed correctly
				local items
				util.run_in_cwd(params.relative_file_root or task.cwd, function()
					items = vim.fn.getqflist({
						lines = lines,
						efm = params.errorformat,
					}).items
				end)
				items = vim.tbl_filter(function(item)
					return item.valid == 1
				end, items)
				if not vim.tbl_isempty(items) then
					self.has_items = true
					if params.open_on_match then
						copen(self, params.open_height)
						cur_qf = vim.fn.getqflist({ context = 0, id = self.qf_id })
					end
				end
				local what = {
					title = task.name,
					context = task.id,
					items = items,
				}
				if action == "a" then
					-- Only pass the ID if appending to existing list
					what.id = self.qf_id
				end
				vim.fn.setqflist({}, action, what)
				-- Store the quickfix list ID if we don't have one yet
				if self.qf_id == 0 then
					self.qf_id = vim.fn.getqflist({ id = 0 }).id
				end
			end
		}
		return comp
	end,
}

return comp_def
