local M = {}

local defaults = {
  bash = {
    bo = { expandtab = true, shiftwidth = 2 },
    wo = { colorcolumn = "80" },
  },
  cs = {
    bo = { expandtab = true, shiftwidth = 4, softtabstop = 4, tabstop = 4 },
    wo = { colorcolumn = "120" },
  },
  gitcommit = {
    bo = { swapfile = false, textwidth = 72, undofile = false },
    wo = {
      colorcolumn = "50,72",
      foldenable = false,
      number = false,
      relativenumber = false,
      spell = true,
      wrap = false,
    },
  },
  go = {
    bo = { expandtab = true, shiftwidth = 4, softtabstop = 4, tabstop = 4 },
    wo = { colorcolumn = "80" },
  },
  javascript = {
    bo = { expandtab = true, shiftwidth = 2 },
    wo = { colorcolumn = "80" },
  },
  json = {
    bo = { expandtab = true, shiftwidth = 2 },
    wo = { colorcolumn = "120", conceallevel = 0 },
  },
  json5 = {
    bo = { expandtab = true, shiftwidth = 2 },
    wo = { colorcolumn = "120", conceallevel = 0 },
  },
  jsonc = {
    bo = { expandtab = true, shiftwidth = 2 },
    wo = { colorcolumn = "120", conceallevel = 0 },
  },
  lua = {
    bo = {
      expandtab = true,
      shiftwidth = 2,
      keywordprg = ":help",
      include = [=[\v<((do|load)file|require)\s*\(?['"]\zs[^'"]+\ze['"]]=],
      includeexpr = [[v:lua.require("ft.lua").include_expr(v:fname)]],
    },
    wo = { colorcolumn = "120" },
  },
  markdown = {
    bo = { formatlistpat = [=[^\s*\d\+\.\s\+\|^\s*[-*+>]\s\+\|^\[^\ze[^\]]\+\]:]=] },
    wo = {
      breakindent = true,
      breakindentopt = "min:5,list:-1",
      concealcursor = "n",
      conceallevel = 2,
      iskeyword = vim.opt.iskeyword:append "-",
      listchars = vim.opt.listchars:append "eol: ",
      spell = false,
      wrap = true,
    },
  },
  python = {
    bo = { expandtab = true, shiftwidth = 4, softtabstop = 4, tabstop = 4 },
    wo = { colorcolumn = "80" },
  },
  rust = {
    bo = { expandtab = true, shiftwidth = 4, softtabstop = 4, tabstop = 4 },
    wo = { colorcolumn = "100" },
  },
  sh = {
    bo = { expandtab = true, shiftwidth = 2 },
    wo = { colorcolumn = "80" },
  },
  sql = {
    bo = { expandtab = true, shiftwidth = 4, softtabstop = 4, tabstop = 4 },
    wo = { colorcolumn = "80", relativenumber = false },
  },
  typescript = {
    bo = { expandtab = true, shiftwidth = 2 },
    wo = { colorcolumn = "80" },
  },
  zsh = {
    bo = { expandtab = true, shiftwidth = 2 },
    wo = { colorcolumn = "80" },
  },
  ["vim"] = {
    bo = { expandtab = true, shiftwidth = 2 },
    wo = { colorcolumn = "120", foldmethod = "marker" },
  },
}

---@param buf number
---@param bo vim.bo
M.bo = function(buf, bo)
  for k, v in pairs(bo or {}) do
    vim.api.nvim_set_option_value(k, v, { buf = buf })
  end
end

---@param win number
---@param wo vim.wo
M.wo = function(win, wo)
  for k, v in pairs(wo or {}) do
    vim.api.nvim_set_option_value(k, v, { win = win, scope = "local" })
  end
end

---@param buf number
M.setup = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype or ""
  local opts = defaults[ft] or {}
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then return end
    if not vim.b[buf].ts_highlight then
      opts = vim.tbl_deep_extend("force", opts, { wo = { relativenumber = false } })
    end
    M.wo(win, opts.wo)
  end
  M.bo(buf, opts.bo)
end

return M
