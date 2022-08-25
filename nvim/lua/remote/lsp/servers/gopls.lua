local icons = require "ui.icons"

local M = {}

M.config = {
  settings = {
    gopls = {
      analyses = {
        fieldalignment = false,
        fillreturns = true,
        nilness = true,
        nonewvars = true,
        shadow = true,
        ST1003 = true,
        undeclaredname = true,
        unreachable = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      buildFlags = { "-tags", "integration" },
      completeUnimported = true,
      diagnosticsDelay = "500ms",
      experimentalWatchedFileDelay = "200ms",
      gofumpt = false,
      matcher = "Fuzzy",
      staticcheck = true,
      symbolMatcher = "fuzzy",
      usePlaceholders = true,
    },
  },
}

vim.api.nvim_create_augroup("golang_type_hints", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "CursorHold" }, {
  group = "golang_type_hints",
  pattern = { "*.go", "*.mod" },
  callback = function()
    require("remote.lsp.servers.gopls").show_inlay_hints()
  end,
})

local namespace = vim.api.nvim_create_namespace "experimental/inlayHints"
local enabled = false

local get_params = function()
  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")
  local params = {
    range = {
      ["start"] = { character = 0, line = 0 },
      ["end"] = { character = 0, line = 0 },
    },
  }
  local len = vim.api.nvim_buf_line_count(0)
  if end_pos[1] <= len then
    params = vim.lsp.util.make_given_range_params()
  end
  params["range"]["start"]["line"] = 0
  params["range"]["end"]["line"] = vim.api.nvim_buf_line_count(0) - 1
  return params
end

local parse_hints = function(result)
  local map = {}
  if type(result) ~= "table" then
    return {}
  end
  for _, value in pairs(result) do
    local range = value.position
    local line = value.position.line
    local label = value.label
    local kind = value.kind
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    if map[line] ~= nil then
      table.insert(map[line], { label = label, kind = kind, range = range })
    else
      map[line] = { { label = label, kind = kind, range = range } }
    end
  end
  return map
end

local get_max_len = function(bufnr, parsed_data)
  local max_len = -1
  for key, _ in pairs(parsed_data) do
    local line = tonumber(key)
    local current_line = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
    if current_line then
      local current_line_len = string.len(current_line)
      max_len = math.max(max_len, current_line_len)
    end
  end
  return max_len
end

local handler = function(err, result, ctx)
  if err then
    return
  end
  local bufnr = ctx.bufnr
  if vim.api.nvim_get_current_buf() ~= bufnr then
    return
  end
  local function unpack_label(label)
    local labels = ""
    for _, value in pairs(label) do
      labels = labels .. " " .. value.value
    end
    return labels
  end
  M.remove_inlay_hints()
  local parsed = parse_hints(result)
  for key, value in pairs(parsed) do
    local virt_text = ""
    local line = tonumber(key)
    local current_line = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
    if current_line then
      local current_line_len = string.len(current_line)
      local param_hints = {}
      local other_hints = {}
      for _, value_inner in ipairs(value) do
        if value_inner.kind == 2 then
          table.insert(param_hints, unpack_label(value_inner.label))
        end
        if value_inner.kind == 1 then
          table.insert(other_hints, value_inner)
        end
      end
      local parameter_hint_prefix = ":"
      local type_hint_prefix = icons.misc.RightArrow
      if not vim.tbl_isempty(param_hints) then
        virt_text = virt_text .. parameter_hint_prefix .. "("
        for i, value_inner_inner in ipairs(param_hints) do
          virt_text = virt_text .. value_inner_inner:sub(2, -2)
          if i ~= #param_hints then
            virt_text = virt_text .. ", "
          end
        end
        virt_text = virt_text .. ") "
      end
      if not vim.tbl_isempty(other_hints) then
        virt_text = virt_text .. type_hint_prefix
        for i, value_inner_inner in ipairs(other_hints) do
          if value_inner_inner.kind == 2 then
            local char_start = value_inner_inner.range.start.character
            local char_end = value_inner_inner.range["end"].character
            local variable_name = string.sub(current_line, char_start + 1, char_end)
            virt_text = virt_text .. variable_name .. ": " .. value_inner_inner.label
          else
            local label = unpack_label(value_inner_inner.label)
            if string.sub(label, 1, 2) == ": " then
              virt_text = virt_text .. label:sub(3)
            else
              virt_text = virt_text .. label
            end
          end
          if i ~= #other_hints then
            virt_text = virt_text .. ", "
          end
        end
      end
      if virt_text ~= "" then
        vim.api.nvim_buf_set_extmark(bufnr, namespace, line, 0, {
          virt_text_pos = "eol",
          virt_text = {
            { virt_text, "Comment" },
          },
          hl_mode = "combine",
        })
      end
      enabled = true
    end
  end
end

M.remove_inlay_hints = function()
  vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
end

M.show_inlay_hints = function()
  for _, lsp in pairs(vim.lsp.get_active_clients()) do
    if lsp.name == "gopls" then
      vim.lsp.buf_request(0, "textDocument/inlayHint", get_params(), handler)
      break
    end
  end
end

return M
