local M = {}

M.get_diagnostics = function(bufnr)
  local result = {}
  local levels = {
    error = vim.diagnostic.severity.ERROR,
    warn = vim.diagnostic.severity.WARN,
    info = vim.diagnostic.severity.INFO,
    hint = vim.diagnostic.severity.HINT,
  }
  for k, level in pairs(levels) do
    result[k] = #vim.diagnostic.get(bufnr, { severity = level })
  end
  return result
end

M.get_messages = function(bufnr)
  if #vim.lsp.get_active_clients { bufnr = bufnr } == 0 then
    return ""
  end
  local messages = {}
  local buf_messages = vim.lsp.util.get_progress_messages()
  for _, msg in ipairs(buf_messages) do
    local contents = ""
    if msg.percentage and msg.percentage == 0 then
      return ""
    end
    if msg.progress then
      contents = msg.title
      if msg.message then
        contents = string.format("%s %s", contents, msg.message)
      end
      if msg.percentage then
        contents = string.format("%s (%s)", contents, msg.percentage)
      end
    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ":~:.")
        local maxlen = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > maxlen then
          filename = vim.fn.pathshorten(filename)
        end
        contents = string.format("(%s) %s", filename, contents)
      end
    else
      contents = msg.content
    end
    table.insert(messages, string.format("[%s] %s", msg.name, contents))
  end
  if next(messages) then
    return table.concat(messages, " ")
  end
  return ""
end

return M
