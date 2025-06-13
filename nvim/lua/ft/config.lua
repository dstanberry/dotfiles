return {
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
  javascriptreact = {
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
  typescriptreact = {
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
  -- misc
  checkhealth = {
    wo = {
      number = false,
      relativenumber = false,
      winhighlight = "FloatBorder:FloatBorderSB",
    },
  },
}
