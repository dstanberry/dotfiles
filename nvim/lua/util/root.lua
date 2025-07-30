---@class util.root
---@overload fun(): string
local M = setmetatable({}, {
  __call = function(m, ...) return m.get(...) end,
})

---@alias util.root.detector_fn fun(buf: number): (string|string[])
---@alias util.root.resolver_spec string|string[]|util.root.detector_fn

---@class util.root.dirs
---@field paths string[]
---@field spec util.root.resolver_spec

---@type table<number, string>
M.cached_roots = {}
---@type table<number, string>
M.cached_specs = {}

---Detects the root directories of a given file/buffer using specific algorithm.
---@alias util.root.detectors.kind fun(buf?: number|string, patterns?: string[]|string): string[]
---@type table<string, util.root.detectors.kind>
M.detectors = {}

local default_spec = { "lsp", { ".git" }, "cwd" }

local normalize = function(path)
  if path:sub(1, 1) == "~" then
    local home = vim.uv.os_homedir()
    if home and (home:sub(-1) == "\\" or home:sub(-1) == "/") then home = home:sub(1, -2) end
    path = home .. path:sub(2)
  end
  path = path:gsub("\\", "/"):gsub("/+", "/")
  return path:sub(-1) == "/" and path:sub(1, -2) or path
end

local realpath = function(path)
  if path == "" or path == nil then return nil end
  path = vim.uv.fs_realpath(path) or path
  return normalize(path)
end

local bufpath = function(buf) return realpath(vim.api.nvim_buf_get_name(assert(buf))) end

---@diagnostic disable-next-line: unused-local, unused-function
local cwd = function() return realpath(vim.uv.cwd()) end

---Detects the root directories based on the current working directory.
---@return util.root.dirs[]
function M.detectors.cwd() return { vim.uv.cwd() } end

---Detects the root directories based on LSP workspace folders or root_dir.
---@param buf number Buffer number
---@return util.root.dirs[]
function M.detectors.lsp(buf)
  local filepath = bufpath(buf)
  if not filepath then return {} end
  local roots = {} ---@type string[]
  for _, client in pairs(vim.lsp.get_clients { bufnr = buf }) do
    local workspace = client.config.workspace_folders
    for _, ws in pairs(workspace or {}) do
      roots[#roots + 1] = vim.uri_to_fname(ws.uri)
    end
    if client.root_dir then roots[#roots + 1] = client.root_dir end
  end
  return vim.tbl_filter(function(path)
    path = normalize(path)
    return path and filepath:find(path, 1, true) == 1
  end, roots)
end

---Detects the root directories based on patterns.
---@param buf number|string Buffer number or filename
---@param patterns string[]|string Patterns to match
---@return string[] List of detected root directories
function M.detectors.pattern(buf, patterns)
  patterns = type(patterns) == "string" and { patterns } or patterns
  local filepath = type(buf) == "number" and (bufpath(buf) or vim.uv.cwd()) or tostring(buf)
  local pattern = vim.fs.find(function(name)
    for _, p in ipairs(patterns) do
      if name == p then return true end
      if p:sub(1, 1) == "*" and name:find(vim.pesc(p:sub(2)) .. "$") then return true end
    end
    return false
  end, { path = filepath, upward = true })[1]
  return pattern and { vim.fs.dirname(pattern) } or {}
end

---Resolves a detector function based on the given specification.
---@param spec util.root.resolver_spec Specification for the detector
---@return util.root.detector_fn Resolved detector function
function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  elseif type(spec) == "function" then
    return spec
  end
  return function(buf) return M.detectors.pattern(buf, spec) end
end

---Detects root directories based on the provided options.
---@param opts? { buf?: number, spec?: util.root.resolver_spec[], all?: boolean }
function M.detect(opts)
  opts = opts or {}
  opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf
  opts.spec = opts.spec or M.cached_specs[opts.buf] or default_spec

  local ret = {} ---@type util.root.dirs[]
  for _, spec in ipairs(opts.spec) do
    local paths = M.resolve(spec)(opts.buf)
    paths = paths or {}
    paths = type(paths) == "table" and paths or { paths }
    local roots = {} ---@type string[]
    for _, p in ipairs(paths) do
      local pp = realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then roots[#roots + 1] = pp end
    end
    table.sort(roots, function(a, b) return #a > #b end)
    if #roots > 0 then
      ret[#ret + 1] = { spec = spec, paths = roots }
      if opts.all == false then break end
    end
  end
  return ret
end

---Lists the detected root directories.
function M.list()
  local spec = M.cached_specs[vim.api.nvim_get_current_buf()] or default_spec
  local roots = M.detect { all = true }
  local lines = {} ---@type string[]
  local first = true
  for _, root in ipairs(roots) do
    for _, path in ipairs(root.paths) do
      lines[#lines + 1] = ("- [%s] `%s` **(%s)**"):format(
        first and "x" or " ",
        path,
        type(root.spec) == "table" and table.concat(root.spec, ", ") or root.spec
      )
      first = false
    end
  end
  lines[#lines + 1] = "```lua"
  lines[#lines + 1] = "root_detectors = " .. vim.inspect(spec)
  lines[#lines + 1] = "```"
  ds.info(lines, { title = "Root Workspace(s)", ft = "markdown" })
end

---Return the root directory for the current document based on:
---* lsp workspace folders
---* lsp root_dir
---* root pattern of filename of the current buffer
---* root pattern of cwd
---@param opts? {normalize?:boolean, buf?:number}
---@return string|nil
function M.get(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local ret = M.cached_roots[buf]
  if not ret then
    local roots = M.detect { all = false, buf = buf }
    ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
    M.cached_roots[buf] = ret
  end
  if opts and opts.normalize then return ret end
  return (ds.has "win32" and ret) and ret:gsub("/", "\\") or ret
end

---Sets up the root module by creating necessary autocommands and user commands.
function M.setup()
  vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost", "DirChanged" }, {
    group = ds.augroup "root_cache",
    callback = function(event)
      M.cached_roots[event.buf] = nil
      M.cached_specs[event.buf] = nil
    end,
  })

  vim.api.nvim_create_user_command("Workspace", function(opts)
    local cmd = unpack(opts.fargs)
    if not cmd or cmd == "list" then
      M.list()
    elseif cmd == "add" then
      vim.lsp.buf.add_workspace_folder()
    elseif cmd == "remove" then
      vim.lsp.buf.remove_workspace_folder()
    else
      ds.error(("Invalid workspace operation: '%s'"):format(cmd), { title = "Root Workspace(s)" })
    end
  end, {
    nargs = "*",
    complete = function(_, line)
      local l = vim.split(line, "%s+")
      local n = #l - 2
      if n == 0 then
        return vim.tbl_filter(function(val) return vim.startswith(val, l[2]) end, { "list", "add", "remove" })
      end
    end,
  })
end

return M
