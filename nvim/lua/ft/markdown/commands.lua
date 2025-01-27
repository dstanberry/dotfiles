local markdown = require "ft.markdown"

local find_recent = function() markdown.zk.edit({ createdAfter = "2 weeks ago" }, { title = "Notes (recent)" }) end

local find_orphaned = function()
  markdown.zk.edit({ orphan = true, excludeHrefs = { "resources" } }, { title = "Notes (orphaned)" })
end

local find_templated = function(template)
  markdown.zk.edit({ hrefs = { template }, sort = { "created" } }, { title = string.format("Notes (%s)", template) })
end

vim.api.nvim_create_user_command("ZkOrphans", find_orphaned, {})
vim.api.nvim_create_user_command("ZkRecent", find_recent, {})
vim.api.nvim_create_user_command("ZkDaily", function() find_templated "journal" end, {})
vim.api.nvim_create_user_command("ZkMeeting", function() find_templated "inbox" end, {})
vim.api.nvim_create_user_command("ZkResource", function() find_templated "resources" end, {})

vim.api.nvim_create_user_command("ZkGrep", function(opts)
  local options = {}
  options.notebook_path = opts.fargs and unpack(opts.fargs) or ""
  markdown.zk.live_grep(options)
end, { nargs = "?" })

vim.api.nvim_create_user_command("ZkReference", function(opts)
  local options = {}
  options.location = opts.fargs and unpack(opts.fargs) or ""
  markdown.zk.new_from_selection(options)
end, {
  nargs = "?",
  range = true,
  force = true,
  complete = function(_, line)
    local lines = vim.split(line, "%s+")
    if #lines == 2 then
      return vim.tbl_filter(function(val) return vim.startswith(val, lines[2]) end, { "title", "content" })
    end
  end,
})
