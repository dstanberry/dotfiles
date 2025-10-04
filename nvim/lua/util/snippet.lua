---@class util.snippet
local M = {}

---Replace nested placeholders in a snippet with LSP placeholders.
---@param snippet string # The snippet string containing placeholders.
---@return string # The snippet with placeholders replaced.
function M._fix(snippet)
  local texts = {} ---@type table<number, string>
  return M._replace(snippet, function(placeholder)
    texts[placeholder.n] = texts[placeholder.n] or M._preview(placeholder.text)
    return "${" .. placeholder.n .. ":" .. texts[placeholder.n] .. "}"
  end)
end

---Resolve nested placeholders in a snippet.
---@param snippet string # The snippet string to resolve.
---@return string # The resolved snippet string.
function M._preview(snippet)
  local ok, parsed = pcall(function() return vim.lsp._snippet_grammar.parse(snippet) end)
  return ok and tostring(parsed)
    or M._replace(snippet, function(placeholder) return M._preview(placeholder.text) end):gsub("%$0", "")
end

---@alias util.snippet.placeholder {n:number, text:string}

---Replace placeholders in a snippet using a custom function.
---@param snippet string # The snippet string containing placeholders.
---@param fn fun(placeholder: util.snippet.placeholder): string # Function to process each placeholder.
---@return string # The snippet with placeholders replaced.
function M._replace(snippet, fn)
  return snippet:gsub("%$%b{}", function(m)
    local n, name = m:match "^%${(%d+):(.+)}$"
    return n and fn { n = n, text = name } or m
  end) or snippet
end

---Check if there is an active snippet session.
---@param filter? table # Optional filter to constrain the search.
---@return boolean # `true` if a snippet session is active, `false` otherwise.
function M.active(filter)
  filter = vim.tbl_deep_extend("force", { direction = 1 }, filter or {})
  return vim.snippet and vim.snippet.active(filter)
end

---Expand the given snippet text.
---Tabstops are highlighted with |hl-SnippetTabstop|.
---@param snippet string # The snippet string to expand.
function M.expand(snippet)
  local session = (vim.snippet and vim.snippet.active()) and vim.snippet._session or nil
  local ok, err = pcall(vim.snippet.expand, snippet)

  if not ok then
    ok = pcall(vim.snippet.expand, M._fix(snippet))

    local msg = ok and "Failed to parse snippet,\nbut was able to fix it automatically."
      or ("Failed to parse snippet.\n" .. err)

    ds[ok and "warn" or "error"](
      ([[%s
        ```%s
        %s
        ```
      ]]):format(msg, vim.bo.filetype, snippet),
      { id = "ds.util.snippet", title = "Snippet" }
    )
  end

  if session then vim.snippet._session = session end
end

---(If possible) Jump to the next (or previous) placeholder in the current snippet.
---@param direction (vim.snippet.Direction) Navigation direction. -1 for previous, 1 for next.
---@return boolean|nil # `true` if the jump was successful, `false` otherwise.
function M.jump(direction)
  if vim.snippet.active { direction = direction } then
    vim.schedule(function()
      if vim.snippet then vim.snippet.jump(direction) end
    end)
    return true
  end
end

---Exit the current snippet.
function M.stop()
  if vim.snippet then vim.snippet.stop() end
end

return M
