local M = {}

--- Create autocommand group based on the given definition
--- Also creates the augroup automatically if it doesn't exist
--- @param event string | string[]: The event to trigger the autocommand
--- @param opts table: The options for the autocommand
--- @return nil
function M.define_autocmd(event, opts)
	if type(opts.group) == "string" and opts.group ~= "" then
		local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
		if not exists then
			vim.api.nvim_create_augroup(opts.group, {})
		end
	end
	vim.api.nvim_create_autocmd(event, opts)
end

--- Create autocommand groups based on the passed definitions
--- Also creates the augroup automatically if it doesn't exist
--- @param definitions table: The definitions of the autocommands
function M.define_autocmds(definitions)
	for _, entry in ipairs(definitions) do M.define_autocmd(entry[1], entry[2]) end
end

--- Clean autocommand in a group if it exists
--- This is safer than trying to delete the augroup itself
function M.clear_augroup(name)
	-- defer the function in case the autocommand is still in-use
	vim.schedule(function()
		pcall(function()
			vim.api.nvim_clear_autocmds { group = name }
		end)
	end)
end

return M
