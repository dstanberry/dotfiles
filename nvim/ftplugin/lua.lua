vim.bo.keywordprg = ":help"
vim.opt_local.include = [=[\v<((do|load)file|require)\s*\(?['"]\zs[^'"]+\ze['"]]=]
vim.opt_local.includeexpr = [[v:lua.require("ft.lua").include_expr(v:fname)]]
