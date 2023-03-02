local function get_relative_filepath(url_data)
  if has "win32" then
    local git_root = require("gitlinker.git").get_git_root()
    -- use forward slashes only (browser urls don't use backslash char)
    git_root = git_root:gsub("\\", "/")
    url_data.file = url_data.file:gsub("\\", "/")
    -- HACK: trim git root from file to get relative path.. YMMV
    url_data.file = url_data.file:gsub(git_root, "")
    -- trim leading slash
    if url_data.file:sub(1, 1) == "/" then url_data.file = url_data.file:sub(2) end
  end
  return url_data
end

local function open(url)
  local Job = require "plenary.job"
  local command
  local args = { url }
  if vim.loop.os_uname().sysname == "Darwin" then
    command = "open"
  elseif has "win32" or has "wsl" then
    command = "cmd.exe"
    args = { "/c", "start", url }
  else
    command = "xdg-open"
  end
  Job:new({ command = command, args = args }):start()
end

local function browser() return { action_callback = open } end

local function gitlinker() return require "gitlinker" end

return {
  "ruifm/gitlinker.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- stylua: ignore
  keys = {
    { "<localleader>gy", function() gitlinker().get_buf_range_url "n" end, desc = "gitlinker: copy line" },
    { "<localleader>go", function() gitlinker().get_buf_range_url('n', browser()) end, desc = "gitlinker: open line in browser" },
    { "<localleader>gy", function() gitlinker().get_buf_range_url "v" end, mode = "v", desc = "neogit: copy selection" },
    { "<localleader>go", function() gitlinker().get_buf_range_url('v', browser()) end, mode = "v", desc = "gitlinker: open selection in browser" },
  },
  opts = {
    mappings = nil,
    callbacks = {
      ["github.com"] = function(url_data)
        url_data = get_relative_filepath(url_data)
        return require("gitlinker.hosts").get_github_type_url(url_data)
      end,
    },
  },
  config = function(_, opts)
    local github_work = vim.g.config_github_work
    if github_work then
      opts.callbacks[github_work] = function(url_data)
        url_data = get_relative_filepath(url_data)
        return require("gitlinker.hosts").get_github_type_url(url_data)
      end
    end
    require("gitlinker").setup(opts)
  end,
}
