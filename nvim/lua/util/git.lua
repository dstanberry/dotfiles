---@class util.git
local M = {}

---@param remote {name: string, url: string}
local open = function(remote)
  if remote then
    print(("Opening [%s](%s)"):format(remote.name, remote.url))
    vim.ui.open(remote.url)
  end
end

local remote_patterns = {
    -- stylua: ignore start
    { "^(https?://.*)%.git$"              , "%1" },
    { "^git@(.+):(.+)%.git$"              , "https://%1/%2" },
    { "^git@(.+):(.+)$"                   , "https://%1/%2" },
    { "^git@(.+)/(.+)$"                   , "https://%1/%2" },
    { "^ssh://git@(.*)$"                  , "https://%1" },
    { "^ssh://([^:/]+)(:%d+)/(.*)$"       , "https://%1/%3" },
    { "^ssh://([^/]+)/(.*)$"              , "https://%1/%2" },
    { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
    { "^https://%w*@(.*)"                 , "https://%1" },
    { "^git@(.*)"                         , "https://%1" },
    { ":%d+"                              , "" },
    { "%.git$"                            , "" },
  -- stylua: ignore end
}

---Converts `remote` into a URL, ensuring it begins with "https://"
---@param remote string
function M.get_url(remote)
  local ret = remote
  for _, pattern in ipairs(remote_patterns) do
    ret = ret:gsub(pattern[1], pattern[2])
  end
  return ret:find "https://" == 1 and ret or ("https://%s"):format(ret)
end

---Attempt to open the git repository url for the current buffer in an external process.
function M.browse_remote()
  local proc = vim.system({ "git", "remote", "-v" }, { text = true }):wait()
  if proc.code ~= 0 then return ds.warn("Unable to find git remotes", { title = "Git Browse" }) end

  local lines = vim.split(proc.stdout, "\n")

  proc = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }):wait()
  if proc.code ~= 0 then return ds.warn("Unable to find current git branch", { title = "Git Browse" }) end

  local branch = proc.stdout:gsub("\n", "")
  local remotes = {} ---@type {name:string, url:string}[]

  for _, line in ipairs(lines) do
    local name, remote = line:match "(%S+)%s+(%S+)%s+%(fetch%)"
    if name and remote then
      local url = M.get_url(remote)
      if url:find "github" and branch and branch ~= "master" and branch ~= "main" then
        url = ("%s/tree/%s"):format(url, branch)
      end
      if url then table.insert(remotes, { name = name, url = url }) end
    end
  end

  if #remotes == 0 then
    return print "No git remotes found"
  elseif #remotes == 1 then
    return open(remotes[1])
  end

  vim.ui.select(remotes, {
    prompt = "Select remote to browse",
    format_item = function(item)
      return item.name .. (" "):rep(8 - #item.name) .. ds.pad(ds.icons.misc.Link, "both") .. item.url
    end,
  }, open)
end

return M
