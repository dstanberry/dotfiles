---------------------------------------------------------------
-- => Tree-Sitter Configuration
---------------------------------------------------------------
-- verify tree-sitter is available
local has_treesitter, treesitter_configs =
  pcall(require, 'nvim-treesitter.configs')
if not has_treesitter then
  return
end

-- helper function to load language scheme
local read_query = function(language, filename)
  local front = '/vim/lua/remote/tree-sitter/queries'
  local back = '/' .. language .. '/' .. filename .. '.scm'
  local path = os.getenv('XDG_CONFIG_HOME') .. front .. back
  return table.concat(vim.fn.readfile(vim.fn.expand(path)), "\n")
end

-- add local language schemes
local languages = {vim = {'highlights', 'injections'}}

for lang, list in pairs(languages) do
  for _, scheme in ipairs(list) do
    vim.treesitter.set_query(lang, scheme, read_query(lang, scheme))
  end
end

-- set default options
treesitter_configs.setup {
  ensure_installed = {
    'bash', 'c', 'c_sharp', 'comment', 'cpp', 'css','go', 'html', 'java',
    'javascript', 'jsdoc', 'jsonc', 'lua', -- [[ 'markdown', ]]
    'php', 'python', 'toml', 'query', 'regex', 'ruby', -- [[ 'vim', ]]
    'yaml'
  },
  highlight = {enable = true, use_languagetree = false, disable = {}},
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<localleader>gi',
      node_incremental = '<localleader>gn',
      scope_incremental = '<localleader>gs',
      node_decremental = '<localleader>gd'
    }
  },
  refactor = {
    highlight_definitions = {enable = true},
    highlight_current_scope = {enable = false},
    smart_rename = {
      enable = false,
      keymaps = {smart_rename = '<localleader>g/'}
    }
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['<localleader>fa'] = '@function.outer',
        ['<localleader>fi'] = '@function.inner',
        ['<localleader>ca'] = '@conditional.outer',
        ['<localleader>ci'] = '@conditional.inner',
        ['<localleader>aa'] = '@parameter.outer',
        ['<localleader>ii'] = '@parameter.inner'
      }
    },
    swap = {
      enable = true,
      swap_next = {
        ["<localleader>snp"] = "@parameter.inner",
        ["<localleader>snf"] = "@function.outer"
      },
      swap_previous = {
        ["<localleader>spp"] = "@parameter.inner",
        ["<localleader>spf"] = "@function.outer"
      }
    }
  }
}
