-- verify gitlinker is available
local ok, gitlinker = pcall(require, "gitlinker")
if not ok then
  return
end

gitlinker.setup {
  opts = {
    remote = nil,
    add_current_line_on_normal_mode = true,
    action_callback = require("gitlinker.actions").copy_to_clipboard,
    print_url = true,
  },
  callbacks = {
    ["github.com"] = require("gitlinker.hosts").get_github_type_url,
    ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
  },
  mappings = "<leader>gy",
}
