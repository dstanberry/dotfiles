local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local sorters = require "telescope.sorters"

local M = {}

M.live_grep_with_shortcuts = function(opts)
  opts = opts or {}
  opts.layout_strategy = "vertical"
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  opts.shortcuts = opts.shortcuts or {
    ["l"] = "*.lua",
    ["v"] = "*.vim",
  }
  opts.pattern = opts.pattern or "%s"
  local custom_grep = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end
      local prompt_split = vim.split(prompt, "  ")
      local args = { "rg" }
      if prompt_split[1] then
        table.insert(args, "-e")
        table.insert(args, prompt_split[1])
      end
      if prompt_split[2] then
        table.insert(args, "-g")
        local pattern
        if opts.shortcuts[prompt_split[2]] then
          pattern = opts.shortcuts[prompt_split[2]]
        else
          pattern = prompt_split[2]
        end
        table.insert(args, string.format(opts.pattern, pattern))
      end
      return vim.tbl_flatten {
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers.new(opts, {
    debounce = 100,
    prompt_title = "Live Grep (with shortcuts)",
    finder = custom_grep,
    previewer = conf.grep_previewer(opts),
    sorter = sorters.empty(),
  }):find()
end

return M
