local M = {}

M.color = require "util.color"
M.buffer = require "util.buffer"
M.map = require "util.map"
M.packer = require "util.packer"

function M.reload(name)
  local ok, r = pcall(require, "plenary.reload")
  if ok then
    r.reload_module(name)
  end
  return require(name)
end

M.callbacks = {}

function M.delegate(cb, expr)
  local key = tostring(cb)
  M.callbacks[key] = cb
  if expr then
    return ([[luaeval('require("util").execute("%s")')]]):format(key)
  end
  return ([[lua require("util").execute("%s")]]):format(key)
end

function M.execute(id)
  local func = M.callbacks[id]
  if not func then
    print("Function doest not exist: " .. id)
  end
  return func()
end

function M.define_command(spec)
  local name = spec.name
  local force = spec.force and "!" or ""
  local bang = spec.bang and "-bang" or ""
  local complete = spec.complete and "-complete" or ""
  local nargs = spec.nargs and "-nargs" or ""
  local range = spec.range and "-range" or ""
  local action = spec.command or ""
  if spec.callback ~= nil and type(spec.callback) == "function" then
    action = M.delegate(spec.callback)
  end
  local command = table.concat(
    vim.tbl_flatten { ("command%s"):format(force), bang, complete, nargs, range, name, action },
    " "
  )
  vim.cmd(command)
end

function M.define_autocmd(spec)
  local event = spec.event
  if type(event) == "table" then
    event = table.concat(event, ",")
  end
  local pattern = spec.pattern or "*"
  if type(pattern) == "table" then
    pattern = table.concat(pattern, ",")
  end
  local once = spec.once and "++once" or ""
  local nested = spec.nested and "++nested" or ""
  local action = spec.command or ""
  if spec.callback ~= nil and type(spec.callback) == "function" then
    action = M.delegate(spec.callback)
  end
  local command = table.concat(vim.tbl_flatten { "autocmd", event, pattern, once, nested, action }, " ")
  vim.cmd(command)
end

function M.define_augroup(group)
  local clear_suffix = group.buf and " * <buffer>" or ""
  vim.cmd("augroup " .. group.name)
  vim.cmd("autocmd!" .. clear_suffix)
  for _, autocmd in ipairs(group.autocmds) do
    M.define_autocmd(autocmd)
    vim.cmd "augroup END"
  end
end

function M.load_dirhash(s)
  if s == nil then
    print "cannot load hashes without specifying shell"
    return
  end
  local shell
  if s:find "bash" then
    shell = "bash"
  elseif s:find "zsh" then
    shell = "zsh"
  else
    shell = s
  end
  if shell ~= "bash" and shell ~= "zsh" then
    print("cannot load hashes for unsupported shell: " .. shell)
    return
  end
  local config_home = vim.fn.stdpath "config"
  local path = vim.fn.expand(("%s/%s/rc.private/hashes.%s"):format(config_home, shell, shell))
  local cmd = ([[%s -c "source %s; hash -d"]]):format(shell, path)
  local dirs = vim.fn.system(cmd)
  local lines = vim.split(dirs, "\n")
  for _, line in pairs(lines) do
    local pair = vim.split(line, "=")
    if #pair == 2 then
      local var = pair[1]
      local dir = pair[2]
      if vim.env["hash_" .. var] == nil then
        vim.env["hash_" .. var] = dir
      end
    end
  end
end

return M
