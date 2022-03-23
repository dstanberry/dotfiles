local zk = require "remote.lsp.servers.zk"
local telescope = require "remote.telescope"
local previewers = require "telescope.previewers"
local putils = require "telescope.previewers.utils"

local M = {}

local templates = {
  {
    label = "Permanent note",
    directory = "resources",
    ask_for_title = true,
  },
  {
    label = "Team standup",
    directory = "inbox",
    ask_for_title = false,
  },
  {
    label = "Backlog refinement meeting",
    directory = "inbox",
    ask_for_title = false,
  },
  {
    label = "Feature replenishment meeting",
    directory = "inbox",
    ask_for_title = false,
  },
  {
    label = "Other meeting",
    directory = "inbox",
    ask_for_title = true,
  },
  {
    label = "One-on-one",
    directory = "journal",
    ask_for_title = false,
  },
  {
    label = "Literature note",
    directory = "journal",
    ask_for_title = true,
  },
  {
    label = "Other note",
    directory = "journal",
    ask_for_title = false,
  },
}

local new = function(selection)
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
  return file
end

M.create_note = function()
  telescope.pickers.create("dropdown", templates, {
    callback = function(selection)
      local file = new(selection)
      if vim.fn.filereadable(file) then
        vim.cmd(string.format("edit %s", file))
      else
        vim.notify("File not found: " .. file, 2)
      end
    end,
  })
end

M.create_reference = function()
  telescope.pickers.create("dropdown", templates, {
    callback = function(selection)
      local file = new(selection)
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

M.list = function(options)
  options = vim.tbl_extend("force", { select = { "filename", "path", "rawContent" } }, options or {})
  local tags = (options and options.tags) and table.concat(options.tags, ", ") or ""
  if #tags > 0 then
    tags = string.format("(tagged with '%s') ", tags)
  end
  zk.list(options, function(notes)
    telescope.pickers.create("ivy", notes, {
      title = string.format([[\ Notes %s/]], tags),
      previewer = previewers.new_buffer_previewer {
        define_preview = function(self, entry)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(entry.value.rawContent, "\n"))
          putils.highlighter(self.state.bufnr, "markdown")
        end,
      },
      entry_maker = function(entry)
        return {
          ordinal = entry.filename,
          display = entry.filename,
          value = entry,
        }
      end,
      callback = function(selection)
        vim.cmd(string.format("edit %s/%s", vim.g.zk_notebook, selection.value.path))
      end,
    })
  end)
end

M.tag_list = function()
  zk.tag.list({}, function(tags)
    telescope.pickers.create("dropdown", tags, {
      multi_select = true,
      entry_maker = function(entry)
        return {
          ordinal = entry.name,
          display = entry.name,
          value = entry,
        }
      end,
      callback = function(selection)
        local selected = {}
        for _, s in pairs(selection) do
          if type(s) == "table" and s.name then
            table.insert(selected, s.name)
          end
        end
        M.list { tags = selected }
      end,
    })
  end)
end

return M
