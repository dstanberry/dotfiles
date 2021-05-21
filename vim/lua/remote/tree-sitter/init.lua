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
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["df"] = "@function.outer",
        ["dF"] = "@class.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    select = {
      enable = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@conditional.outer',
        ['ic'] = '@conditional.inner',
        ['aa'] = '@parameter.outer',
        ['ii'] = '@parameter.inner'
      }
    },
    swap = {
      enable = true,
      swap_next = {
        ["<a-s><a-l>"] = "@parameter.inner",
        ["<a-s><a-j>"] = "@function.outer"
      },
      swap_previous = {
        ["<a-s><a-h>"] = "@parameter.inner",
        ["<a-s><a-k>"] = "@function.outer"
      }
    }
  }
}
