-- verify telescope is available
local ok, _ = pcall(require, "telescope")
if not ok then
  return
end

local telescope = require "remote.telescope"
local pickers = telescope.pickers

local M = {}

local types = {
  {
    ordinal = 1,
    label = "Meeting Note",
    directory = "inbox",
  },
  {
    ordinal = 2,
    label = "Journal Entry",
    directory = "journal",
  },
  {
    ordinal = 3,
    label = "Literature Note",
    directory = "literature",
  },
  {
    ordinal = 4,
    label = "Permanent Note",
    directory = "permanent",
  },
}

local templates = {
  {
    ordinal = 1,
    label = "Team standup",
    directory = "inbox",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 2,
    label = "One-on-one",
    directory = "journal",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 3,
    label = "Iteration retrospective meeting",
    directory = "inbox",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 4,
    label = "Backlog refinement meeting",
    directory = "inbox",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 5,
    label = "Feature replenishment meeting",
    directory = "inbox",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 6,
    label = "Project meeting",
    directory = "inbox",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 7,
    label = "Other meeting",
    directory = "inbox",
    ask_for_title = false,
    prefix_date = true,
  },
  {
    ordinal = 8,
    label = "Literature note",
    directory = "literature",
    ask_for_title = true,
    prefix_date = true,
  },
  {
    ordinal = 9,
    label = "Permanent note",
    directory = "permanent",
    ask_for_title = true,
    prefix_date = true,
  },
  {
    ordinal = 10,
    label = "Other note",
    directory = "journal",
    ask_for_title = true,
    prefix_date = false,
  },
}

M.create_template_reference = function()
  pickers.create_dropdown(templates, {
    callback = function(selection)
      local title = ""
      if selection.value.ask_for_title then
        title = vim.fn.input "Title: "
        if title == "" then
          return
        end
      else
        title = selection.value.label
      end
      local file
      local cmd = string.format(
        'zk new --working-dir "%s" --no-input --title "%s" "%s" --print-path',
        vim.g.zk_notebook,
        title,
        selection.value.directory
      )
      file = vim.fn.system(cmd)
      file = file:gsub("^%s*(.-)%s*$", "%1")
      if vim.fn.filereadable(file) then
        local segments = vim.split(file, "/")
        local filename = segments[#segments]
        filename = filename:gsub(".md", "")
        vim.api.nvim_put({ string.format("[[%s]]", filename) }, "c", true, true)
      else
        vim.notify("File not found: " .. file, 2)
      end
    end,
  })
end

M.create_note = function()
  pickers.create_dropdown(types, {
    callback = function(selection)
      local file
      local cmd = ([[zk new --working-dir "%s" --no-input "%s" --print-path]]):format(
        vim.g.zk_notebook,
        selection.value.directory
      )
      file = vim.fn.system(cmd)
      file = file:gsub("^%s*(.-)%s*$", "%1")
      if vim.fn.filereadable(file) then
        vim.cmd(string.format("edit %s", file))
      else
        vim.notify("File not found: " .. file, 2)
      end
    end,
  })
end

M.highlight_fenced_code_blocks = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end
  pcall(vim.cmd, ("sign unplace * file=%s"):format(vim.fn.expand "%:p"))
  local continue = false
  for lnum = 1, #vim.fn.getline(1, "$"), 1 do
    local line = vim.fn.getline(lnum)
    if (not continue and string.match(line, "^%s*```.*$")) or (not string.match(line, "^%s*```.*$") and continue) then
      continue = true
      vim.cmd(("sign place %s line=%s name=codeblock file=%s"):format(lnum, lnum, vim.fn.expand "%:p"))
    elseif string.match(line, "^%s*```%s*") and continue then
      vim.cmd(("sign place %s line=%s name=codeblock file=%s"):format(lnum, lnum, vim.fn.expand "%:p"))
      continue = false
    end
  end
end

M.insert_checkbox = function()
  vim.api.nvim_put({ "[ ] " }, "c", true, true)
end

M.insert_link = function()
  local url = vim.fn.getreg "*"
  local link = string.format("[](%s)", url)
  local cursor = vim.fn.getpos "."
  vim.api.nvim_put({ link }, "c", true, true)
  vim.fn.setpos(".", { cursor[1], cursor[2], cursor[3] + 1, cursor[4] })
end

local get_lines = function()
  local line_start, line_end
  if vim.fn.getpos("'<")[2] == vim.fn.getcurpos()[2] and vim.fn.getpos("'<")[3] == vim.fn.getcurpos()[3] then
    line_start = vim.fn.getpos("'<")[2]
    line_end = vim.fn.getpos("'>")[2]
  else
    line_start = vim.fn.getcurpos()[2]
    line_end = vim.fn.getcurpos()[2]
  end
  return line_start, line_end, vim.fn.getline(line_start, line_end)
end

M.toggle_bullet = function()
  local newlines = {}
  local line_start, line_end, lines = get_lines()
  for _, line in ipairs(lines) do
    if string.match(line, "^%s*%-%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s", "%1")))
    else
      table.insert(newlines, (string.gsub(line, "^(%s*)", "%1- ")))
    end
  end
  if line_start == line_end then
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  else
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  end
end

M.toggle_checkbox = function()
  local newlines = {}
  local line_start, line_end, lines = get_lines()
  for _, line in ipairs(lines) do
    if string.match(line, "^(%s*)%-%s%[%s%]%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s%[%s%]%s", "%1- [x] ")))
    elseif string.match(line, "^(%s*)%-%s%[x%]%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s%[x%]%s", "%1- ")))
    elseif string.match(line, "^(%s*)%-%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s", "%1- [ ] ")))
    else
      table.insert(newlines, (string.gsub(line, "^(%s*)", "%1- [ ] ")))
    end
  end
  if line_start == line_end then
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  else
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  end
end

return M
