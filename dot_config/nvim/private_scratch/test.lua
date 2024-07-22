-- require
-- snake_case camelCase kebab-case
-- vim.keymap.set("o", "iw", "<Plug>(textobject-iw)", {buffer = true})
vim.keymap.set("o", "iw", function() require('utils.motions').textObject("iw") end, {buffer = true})
