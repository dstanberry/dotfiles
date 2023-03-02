local util = require "util"
local Component = require "ui.statusline.component"
local options = require "ui.statusline.options"

local M = {}

local cached_ft_map = {}

local props = {}
local left_separator
local right_separator

local load_extensions = function()
  local extensions = vim.api.nvim_get_runtime_file("lua/ui/statusline/extensions/*.lua", true)
  for _, file in ipairs(extensions) do
    local mod = util.get_module_name(file)
    local types = require(mod).filetypes or {}
    for _, ft in ipairs(types) do
      cached_ft_map[ft] = mod
    end
  end
end

local draw_section = function(kind, placement, section)
  if type(section) ~= "table" then return {} end
  local status = {}
  for k, component in pairs(section) do
    if kind == "statusline" and placement == "right" then table.insert(status, right_separator) end
    table.insert(status, Component:new(props, component))
    if kind == "statusline" and placement == "left" and k >= 1 then table.insert(status, left_separator) end
  end
  return status
end

M.generate = function(location, win_id)
  if not vim.api.nvim_win_is_valid(win_id) then return "" end
  if #props > 0 then props = {} end
  props.winid = win_id
  props.bufnr = vim.api.nvim_win_get_buf(win_id)
  props.filetype = vim.api.nvim_buf_get_option(props.bufnr, "filetype")
  props.name = vim.fn.bufname(props.bufnr)

  local sections
  local left_section
  local right_section

  local has_ext, ext
  local keys = vim.tbl_keys(cached_ft_map)
  if vim.tbl_contains(keys, props.filetype) then
    local mod = cached_ft_map[props.filetype]
    has_ext, ext = pcall(require, mod)
  end

  if location == "statusline" then
    if has_ext then
      sections = ext.sections or options.get().sections
    else
      sections = options.get().sections
    end
    left_section = table.concat(draw_section("statusline", "left", sections.left), "")
    right_section = table.concat(draw_section("statusline", "right", sections.right), "")
    return ("%s%%=%s "):format(left_section, right_section)
  elseif location == "winbar" then
    if has_ext then
      if not ext.winbar then return "" end
      sections = ext.winbar
    else
      sections = options.get().winbar
    end
    left_section = table.concat(draw_section("winbar", "left", sections.left), "")
    right_section = table.concat(draw_section("winbar", "right", sections.right), "")
    return ("%s%%=%s"):format(left_section, right_section)
  end
end

M.setup = function(config)
  config = vim.F.if_nil(config, {})
  options.set(config)
  load_extensions()

  local left_separator_hl = options.get().separators.left.hl
  local left_separator_symbol = options.get().separators.left.symbol
  left_separator = Component:new({}, { [left_separator_hl] = left_separator_symbol })

  local right_separator_hl = options.get().separators.right.hl
  local right_separator_symbol = options.get().separators.right.symbol
  right_separator = Component:new({}, { [right_separator_hl] = right_separator_symbol })

  vim.o.statusline = ([[%%{%%v:lua.require("ui.statusline").generate("statusline", %s)%%}]]):format(
    vim.api.nvim_get_current_win()
  )

  local set_winbar = function(is_diff)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft, bt = vim.bo[buf].filetype, vim.bo[buf].buftype
      local _, bufid = pcall(vim.api.nvim_buf_get_var, buf, "bufid")
      local value = ([[%%{%%v:lua.require("ui.statusline").generate("winbar", %s)%%}]]):format(win)
      if not is_diff then is_diff = vim.wo[win].diff end
      local keys = vim.tbl_keys(cached_ft_map)
      if
        not is_diff
        and not vim.tbl_contains(options.get().disabled_filetypes, ft)
        and vim.fn.win_gettype(win) == ""
        and bt == ""
        and ft ~= ""
      then
        vim.wo[win].winbar = value
      elseif (vim.wo[win].winbar == nil and is_diff) or vim.tbl_contains(options.get().disabled_filetypes, ft) then
        vim.wo[win].winbar = nil
      elseif vim.tbl_contains(keys, ft) or vim.tbl_contains(keys, bufid) then
        vim.wo[win].winbar = value
      end
    end
  end

  vim.api.nvim_create_augroup("winbar", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "TabNew", "TabEnter" }, {
    group = "winbar",
    callback = function() set_winbar(false) end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = "winbar",
    pattern = { "DiffviewDiffBufRead", "DiffviewDiffBufWinEnter" },
    callback = function() set_winbar(true) end,
  })
end

return M
