local search_pattern = string.format([[^\(%s\)*]], "\t")
local re = vim.regex(search_pattern)
local str = "		local _, indent_len = re:match_str(line)"
vim.print(re:match_str(str))
