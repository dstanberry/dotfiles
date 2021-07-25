-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/demaro/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/demaro/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/demaro/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/demaro/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/demaro/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim"
  },
  LuaSnip = {
    config = { "\27LJ\1\2.\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\19remote.luasnip\frequire\0" },
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/LuaSnip",
    wants = { "friendly-snippets" }
  },
  ["astronauta.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/astronauta.nvim"
  },
  ["buftabline.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/buftabline.nvim"
  },
  ["friendly-snippets"] = {
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/friendly-snippets"
  },
  ["gentoo-syntax"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/gentoo-syntax"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    wants = { "plenary.nvim" }
  },
  ["glow.nvim"] = {
    commands = { "Glow" },
    loaded = false,
    needs_bufread = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/glow.nvim"
  },
  ["lir-git-status.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/lir-git-status.nvim"
  },
  ["lir-mmv.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/lir-mmv.nvim"
  },
  ["lir.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/lir.nvim",
    wants = { "tamago324/lir-git-status.nvim", "tamago324/lir-mmv.nvim" }
  },
  loupe = {
    config = { "\27LJ\1\0028\0\0\2\0\3\0\0054\0\0\0007\0\1\0'\1\0\0:\1\2\0G\0\1\0\27LoupeClearHighlightMap\6g\bvim\0" },
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/loupe"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim"
  },
  ["lua-dev.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/lua-dev.nvim"
  },
  neogit = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/neogit"
  },
  ["nvim-compe"] = {
    after = { "vscode-csharp-snippets", "python-snippets", "LuaSnip", "vim-snippets", "vsc-lua", "friendly-snippets" },
    after_files = { "/home/demaro/.local/share/nvim/site/pack/packer/opt/nvim-compe/after/plugin/compe.vim" },
    config = { "\27LJ\1\2L\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0014\0\0\0%\1\2\0>\0\2\1G\0\1\0\24remote.compe.keymap\17remote.compe\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/nvim-compe",
    wants = { "LuaSnip" }
  },
  ["nvim-dap"] = {
    after = { "one-small-step-for-vimkind", "nvim-dap-python", "nvim-dap-virtual-text" },
    keys = { { "", "<localleader>db" } },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/nvim-dap",
    wants = { "nvim-dap-virtual-text", "nvim-dap-python", "one-small-step-for-vimkind" }
  },
  ["nvim-dap-python"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/nvim-dap-python"
  },
  ["nvim-dap-virtual-text"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/nvim-dap-virtual-text"
  },
  ["nvim-jqx"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/nvim-jqx"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\1\2F\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0014\0\0\0%\1\2\0>\0\2\1G\0\1\0\20remote.lsp.kind\15remote.lsp\frequire\0" },
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    wants = { "lsp_signature.nvim", "lua-dev" }
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22remote.treesitter\frequire\0" },
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-pairs"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-treesitter-pairs"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    config = { "\27LJ\1\2/\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\20remote.devicons\frequire\0" },
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["one-small-step-for-vimkind"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/one-small-step-for-vimkind"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    commands = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" },
    loaded = false,
    needs_bufread = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["python-snippets"] = {
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/python-snippets"
  },
  ["symbols-outline.nvim"] = {
    commands = { "SymbolsOutline" },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/symbols-outline.nvim"
  },
  tabular = {
    after_files = { "/home/demaro/.local/share/nvim/site/pack/packer/opt/tabular/after/plugin/TabularMaps.vim" },
    commands = { "Tabularize" },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/tabular"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope-lsp-handlers.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/telescope-lsp-handlers.nvim"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/telescope-symbols.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\1\2T\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0014\0\0\0%\1\2\0>\0\2\1G\0\1\0\28remote.telescope.keymap\21remote.telescope\frequire\0" },
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    wants = { "plenary.nvim", "popup.nvim", "telescope-fzy-native.nvim", "telescope-fzf-native.nvim", "telescope-project.nvim", "telescope-symbols.nvim", "telescope-lsp-handlers.nvim" }
  },
  ["twilight.nvim"] = {
    load_after = {
      ["zen-mode.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/twilight.nvim"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-easydir"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/vim-easydir"
  },
  ["vim-hexokinase"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/vim-hexokinase"
  },
  ["vim-log-highlighting"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/vim-log-highlighting"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-scriptease"] = {
    commands = { "Messages", "Verbose", "Time" },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/vim-scriptease"
  },
  ["vim-snippets"] = {
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/vim-snippets"
  },
  ["vim-startuptime"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/vim-startuptime"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vsc-lua"] = {
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/vsc-lua"
  },
  ["vscode-csharp-snippets"] = {
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/vscode-csharp-snippets"
  },
  ["zen-mode.nvim"] = {
    after = { "twilight.nvim" },
    commands = { "ZenMode" },
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/zen-mode.nvim",
    wants = { "twilight.nvim" }
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22remote.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-web-devicons
time([[Config for nvim-web-devicons]], true)
try_loadstring("\27LJ\1\2/\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\20remote.devicons\frequire\0", "config", "nvim-web-devicons")
time([[Config for nvim-web-devicons]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\1\2T\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0014\0\0\0%\1\2\0>\0\2\1G\0\1\0\28remote.telescope.keymap\21remote.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: loupe
time([[Config for loupe]], true)
try_loadstring("\27LJ\1\0028\0\0\2\0\3\0\0054\0\0\0007\0\1\0'\1\0\0:\1\2\0G\0\1\0\27LoupeClearHighlightMap\6g\bvim\0", "config", "loupe")
time([[Config for loupe]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\1\2F\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0014\0\0\0%\1\2\0>\0\2\1G\0\1\0\20remote.lsp.kind\15remote.lsp\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
if vim.fn.exists(":StartupTime") ~= 2 then
vim.cmd [[command! -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'vim-startuptime'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Tabularize") ~= 2 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Tabularize lua require("packer.load")({'tabular'}, { cmd = "Tabularize", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Time") ~= 2 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Time lua require("packer.load")({'vim-scriptease'}, { cmd = "Time", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Verbose") ~= 2 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Verbose lua require("packer.load")({'vim-scriptease'}, { cmd = "Verbose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":TSHighlightCapturesUnderCursor") ~= 2 then
vim.cmd [[command! -nargs=* -range -bang -complete=file TSHighlightCapturesUnderCursor lua require("packer.load")({'playground'}, { cmd = "TSHighlightCapturesUnderCursor", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":SymbolsOutline") ~= 2 then
vim.cmd [[command! -nargs=* -range -bang -complete=file SymbolsOutline lua require("packer.load")({'symbols-outline.nvim'}, { cmd = "SymbolsOutline", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":TSPlaygroundToggle") ~= 2 then
vim.cmd [[command! -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Glow") ~= 2 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Glow lua require("packer.load")({'glow.nvim'}, { cmd = "Glow", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":ZenMode") ~= 2 then
vim.cmd [[command! -nargs=* -range -bang -complete=file ZenMode lua require("packer.load")({'zen-mode.nvim'}, { cmd = "ZenMode", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
if vim.fn.exists(":Messages") ~= 2 then
vim.cmd [[command! -nargs=* -range -bang -complete=file Messages lua require("packer.load")({'vim-scriptease'}, { cmd = "Messages", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
end
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <localleader>db <cmd>lua require("packer.load")({'nvim-dap'}, { keys = "<lt>localleader>db", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType gentoo-init-d ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-init-d" }, _G.packer_plugins)]]
vim.cmd [[au FileType gentoo-package-keywords ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-package-keywords" }, _G.packer_plugins)]]
vim.cmd [[au FileType gentoo-env-d ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-env-d" }, _G.packer_plugins)]]
vim.cmd [[au FileType log ++once lua require("packer.load")({'vim-log-highlighting'}, { ft = "log" }, _G.packer_plugins)]]
vim.cmd [[au FileType gentoo-changelog ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-changelog" }, _G.packer_plugins)]]
vim.cmd [[au FileType gentoo-package-properties ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-package-properties" }, _G.packer_plugins)]]
vim.cmd [[au FileType json ++once lua require("packer.load")({'nvim-jqx'}, { ft = "json" }, _G.packer_plugins)]]
vim.cmd [[au FileType gentoo-use-desc ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-use-desc" }, _G.packer_plugins)]]
vim.cmd [[au FileType gentoo-package-use ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-package-use" }, _G.packer_plugins)]]
vim.cmd [[au FileType gentoo-metadata ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-metadata" }, _G.packer_plugins)]]
vim.cmd [[au FileType gentoo-package-make ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-package-make" }, _G.packer_plugins)]]
vim.cmd [[au FileType gentoo-package-license ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-package-license" }, _G.packer_plugins)]]
vim.cmd [[au FileType gentoo-make-conf ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-make-conf" }, _G.packer_plugins)]]
vim.cmd [[au FileType gentoo-conf-d ++once lua require("packer.load")({'gentoo-syntax'}, { ft = "gentoo-conf-d" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-compe'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-log-highlighting/ftdetect/log.vim]], true)
vim.cmd [[source /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-log-highlighting/ftdetect/log.vim]]
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-log-highlighting/ftdetect/log.vim]], false)
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/gentoo-syntax/ftdetect/gentoo.vim]], true)
vim.cmd [[source /home/demaro/.local/share/nvim/site/pack/packer/opt/gentoo-syntax/ftdetect/gentoo.vim]]
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/gentoo-syntax/ftdetect/gentoo.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
