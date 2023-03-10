local M = {}

M.add = function(highlight, items, join)
  local out = ""
  local sep = join and "" or " "
  for _, item in pairs(items) do
    if item ~= "" then
      if out == "" then
        out = item
      else
        out = string.format("%s%s%s", out, sep, item)
      end
    end
  end
  return string.format("%s%s%s", highlight, out, sep)
end

M.highlighter = {
  sanitize = function(group) return "%#" .. group .. "#" end,
  segment = "%=",
  reset = "%*",
}

return M
