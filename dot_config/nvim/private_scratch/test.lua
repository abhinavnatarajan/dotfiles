local toggleterm_open = function()
	local terms = require("toggleterm.terminal")
	local count = vim.v.count
	if count and count >= 1 then
		local term = terms.get_or_create_term(count)
		term:open()
	else
		local ui = require("toggleterm.ui")
		if not ui.open_terminal_view() then
			local term_id = terms.get_toggled_id()
			terms.get_or_create_term(term_id):open()
		end
	end
end

vim.keymap.set("n", "<leader>x", function() toggleterm_open() end, { buffer = true })
