local M = {}

local fallback = function(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys or "", true, true, true), "n", true)
end

M.jump_to_next = vim.schedule_wrap(function(keys)
  if require("luasnip").expand_or_locally_jumpable() then
    require("luasnip").expand_or_jump()
    local blink = package.loaded["blink.cmp"]
    if blink then blink.hide() end
    return
  end
  fallback(keys)
end)

M.jump_to_previous = vim.schedule_wrap(function(keys)
  if require("luasnip").in_snippet() and require("luasnip").jumpable(-1) then
    require("luasnip").jump(-1)
    return
  end
  fallback(keys)
end)

M.next_choice = function(keys)
  if require("luasnip").in_snippet() and require("luasnip").choice_active() then
    require("luasnip").change_choice(1)
    return
  end
  fallback(keys)
end

M.previous_choice = function(keys)
  if require("luasnip").in_snippet() and require("luasnip").choice_active() then
    require("luasnip").change_choice(-1)
    return
  end
  fallback(keys)
end

return M
