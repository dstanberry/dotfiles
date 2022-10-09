local Component = require "ui.statusline.component"
local options = require "ui.statusline.options"

local M = {}

local props = {}
local left_separator
local right_separator

local draw_section = function(kind, placement, section)
  if type(section) ~= "table" then
    return {}
  end
  local status = {}
  for k, component in pairs(section) do
    if kind == "statusline" and placement == "right" then
      table.insert(status, right_separator)
    end
    table.insert(status, Component:new(props, component))
    if  kind == "statusline" and placement == "left" and k >= 1 then
      table.insert(status, left_separator)
    end
  end
  return status
end

M.generate = function(location, win_id)
  if not vim.api.nvim_win_is_valid(win_id) then
    return ""
  end
  if #props > 0 then
    props = {}
  end
  props.winid = win_id
  props.bufnr = vim.api.nvim_win_get_buf(win_id)
  props.filetype = vim.api.nvim_buf_get_option(props.bufnr, "filetype")
  props.name = vim.fn.bufname(props.bufnr)

  local sections
  local left_section
  local right_section
  local has_ext, ext = pcall(require, ("ui.statusline.extensions.%s"):format(props.filetype:lower()))

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
      -- TODO: add winbar configuration for some custom filetypes
      -- sections = ext.winbar or options.get().winbar
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

  left_separator = Component:new({}, { user9 = options.get().separators.left })
  right_separator = Component:new({}, { user9 = options.get().separators.right })

  vim.api.nvim_create_augroup("statusline", { clear = true })
  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "ModeChanged" }, {
    group = "statusline",
    callback = function()
      vim.wo.statusline = string.format(
        [[%%!luaeval('require("ui.statusline").generate("statusline", %s)')]],
        vim.api.nvim_get_current_win()
      )
    end,
  })

  vim.api.nvim_create_augroup("winbar", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost" }, {
    group = "winbar",
    callback = function()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft, bt = vim.bo[buf].filetype, vim.bo[buf].buftype
        local is_diff = vim.wo[win].diff
        if
          not is_diff
          and not vim.tbl_contains(options.get().disabled_filetypes, ft)
          and vim.fn.win_gettype(win) == ""
          and bt == ""
          and ft ~= ""
        then
          vim.wo[win].winbar = string.format(
            [[%%{%%v:lua.require("ui.statusline").generate("winbar", %s)%%}]],
            vim.api.nvim_get_current_win()
          )
        elseif is_diff or vim.tbl_contains(options.get().disabled_filetypes, ft) then
          vim.wo[win].winbar = nil
        end
      end
    end,
  })
end

return M
