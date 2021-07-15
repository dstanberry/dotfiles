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
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/LuaSnip"
  },
  ["buftabline.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/buftabline.nvim"
  },
  ["complextras.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/complextras.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  },
  ["gentoo-syntax"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/gentoo-syntax"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["lir.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/lir.nvim"
  },
  loupe = {
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
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-dap"
  },
  ["nvim-dap-python"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-dap-python"
  },
  ["nvim-dap-virtual-text"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text"
  },
  ["nvim-jqx"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-jqx"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
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
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["one-small-step-for-vimkind"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/one-small-step-for-vimkind"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/playground"
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
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/python-snippets"
  },
  tabular = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/tabular"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim"
  },
  ["telescope-lsp-handlers.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/telescope-lsp-handlers.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["twilight.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/twilight.nvim"
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
  ["vim-json"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/vim-json"
  },
  ["vim-log-highlighting"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/vim-log-highlighting"
  },
  ["vim-ps1"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/vim-ps1"
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
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/vim-snippets"
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
  ["vim-syntax-extra"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/opt/vim-syntax-extra"
  },
  ["vim-tmux-focus-events"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/vim-tmux-focus-events"
  },
  ["vsc-lua"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/vsc-lua"
  },
  ["vscode-csharp-snippets"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/vscode-csharp-snippets"
  },
  ["zen-mode.nvim"] = {
    loaded = true,
    path = "/home/demaro/.local/share/nvim/site/pack/packer/start/zen-mode.nvim"
  }
}

time([[Defining packer_plugins]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
vim.cmd [[command! -nargs=* -range -bang -complete=file Verbose lua require("packer.load")({'vim-scriptease'}, { cmd = "Verbose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Messages lua require("packer.load")({'vim-scriptease'}, { cmd = "Messages", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'vim-startuptime'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Time lua require("packer.load")({'vim-scriptease'}, { cmd = "Time", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType json ++once lua require("packer.load")({'vim-json'}, { ft = "json" }, _G.packer_plugins)]]
vim.cmd [[au FileType c ++once lua require("packer.load")({'vim-syntax-extra'}, { ft = "c" }, _G.packer_plugins)]]
vim.cmd [[au FileType ps1 ++once lua require("packer.load")({'vim-ps1'}, { ft = "ps1" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-json/ftdetect/json.vim]], true)
vim.cmd [[source /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-json/ftdetect/json.vim]]
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-json/ftdetect/json.vim]], false)
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-ps1/ftdetect/ps1.vim]], true)
vim.cmd [[source /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-ps1/ftdetect/ps1.vim]]
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-ps1/ftdetect/ps1.vim]], false)
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-ps1/ftdetect/ps1xml.vim]], true)
vim.cmd [[source /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-ps1/ftdetect/ps1xml.vim]]
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-ps1/ftdetect/ps1xml.vim]], false)
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-ps1/ftdetect/xml.vim]], true)
vim.cmd [[source /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-ps1/ftdetect/xml.vim]]
time([[Sourcing ftdetect script at: /home/demaro/.local/share/nvim/site/pack/packer/opt/vim-ps1/ftdetect/xml.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
