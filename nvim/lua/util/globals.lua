_G.dump = function(...)
  print(vim.inspect(...))
end

_G.fold_text = function()
  local indent = vim.fn.indent(vim.v.foldstart - 1)
  local indent_level = vim.fn["repeat"](" ", indent)
  local line_count = string.format("[%sℓ]", (vim.v.foldend - vim.v.foldstart + 1))
  local header = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]:gsub(" *", "", 1)
  local level_front = vim.fn["repeat"]("» ", vim.v.foldlevel)
  local level_back = vim.fn["repeat"](" «", vim.v.foldlevel)
  return string.format("%s%s ··· %s%s%s ", indent_level, header, level_front, line_count, level_back)
end

_G.fold_expr = function(lnum)
  if string.find(vim.fn.getline(lnum), "%S") == nil then
    return "-1"
  end
  local get_indent_level = function(n)
    return vim.fn.indent(n) / vim.bo.shiftwidth
  end
  local get_next_line_with_content = function()
    local count = vim.fn.line "$"
    local line = lnum + 1
    while line <= count do
      if string.find(vim.fn.getline(line), "%S") ~= nil then
        return line
      end
      line = line + 1
    end
    return -2
  end
  local current = get_indent_level(lnum)
  local next = get_indent_level(get_next_line_with_content())
  if next <= current then
    return current
  end
  return ">" .. next
end

_G.profile = function(cmd, times)
  times = times or 100
  local args = {}
  if type(cmd) == "string" then
    args = { cmd }
    cmd = vim.cmd
  end
  local start = vim.loop.hrtime()
  for _ = 1, times, 1 do
    local ok = pcall(cmd, unpack(args))
    if not ok then
      error("Command failed: " .. tostring(ok) .. " " .. vim.inspect { cmd = cmd, args = args })
    end
  end
  print(((vim.loop.hrtime() - start) / 1000000 / times) .. "ms")
end

_G.reload = require("util").reload
