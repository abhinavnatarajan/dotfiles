local M = {}

function M.prototype(tbl)
  return setmetatable(tbl,
    {__call = function(_, init)
      return setmetatable(init or {}, {__index = tbl})
    end
    }
  )
end

function M.is_directory(name)
  local stat = vim.loop.fs_stat(name)
  return stat and stat.type == 'directory' or false
end

function M.is_file(name)
  local stat = vim.loop.fs_stat(name)
  return stat and stat.type == 'file' or false
end

function M.str2chars(str)
  local res = {}
  for letter in str:gmatch(".") do res[#res + 1] = letter end
  return res
end

local function max_len_line(lines)
  local max_len = 0

  for _, line in ipairs(lines) do
    local line_len = line:len()
    if line_len > max_len then
      max_len = line_len
    end
  end
  return max_len
end

function M.format_table(entries, col_count, col_sep)
  col_sep = col_sep or " "

  local col_rows = math.ceil(vim.tbl_count(entries) / col_count)
  local cols = {}
  local count = 0

  for i, entry in ipairs(entries) do
    if ((i - 1) % col_rows) == 0 then
      table.insert(cols, {})
      count = count + 1
    end
    table.insert(cols[count], entry)
  end

  local col_max_len = {}
  for _, col in ipairs(cols) do
    table.insert(col_max_len, max_len_line(col))
  end

  local output = {}
  for i, col in ipairs(cols) do
    for j, entry in ipairs(col) do
      if not output[j] then
        output[j] = entry
      else
        local padding = string.rep(" ", col_max_len[i - 1] - cols[i - 1][j]:len())
        output[j] = output[j] .. padding .. col_sep .. entry
      end
    end
  end

  return output
end

return M
