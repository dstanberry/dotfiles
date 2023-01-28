local markdown = require "ft.markdown"

vim.api.nvim_create_user_command("ZkOrphans", function()
  markdown.zk.find_orphans()
end, {})

vim.api.nvim_create_user_command("ZkRecent", function()
  markdown.zk.find_recent_notes()
end, {})

vim.api.nvim_create_user_command("ZkDaily", function()
  markdown.zk.find_templated_note "Journal"
end, {})

vim.api.nvim_create_user_command("ZkMeeting", function()
  markdown.zk.find_templated_note "Inbox"
end, {})

vim.api.nvim_create_user_command("ZkResource", function()
  markdown.zk.find_templated_note "Resources"
end, {})

vim.api.nvim_create_user_command("ZkGrep", function(opts)
  markdown.zk.grep_notes(opts)
end, {})

vim.api.nvim_create_user_command("ZkReference", function(opts)
  markdown.zk.create_note_from_selection(opts)
end, {
  nargs = "?",
  range = true,
  force = true,
  complete = function(_, line)
    local l = vim.split(line, "%s+")
    local n = #l - 2
    if n == 0 then
      return vim.tbl_filter(function(val)
        return vim.startswith(val, l[2])
      end, { "content", "title" })
    end
  end,
})
