vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("typescript", "typescriptreact")

local load_textobjects = false

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function() require "remote.treesitter.context" end,
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
        -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          require("lazy.core.loader").disable_rtp_plugin "nvim-treesitter-textobjects"
          load_textobjects = true
        end,
      },
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/playground",
      "theHamsta/nvim-treesitter-pairs",
    },
    opts = {
      ensure_installed = "all",
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      highlight = {
        enable = true,
        use_languagetree = false,
        -- disable = { "markdown" },
      },
      indent = { enabled = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "=",
          node_incremental = "gn",
          scope_incremental = "<c-a>",
          node_decremental = "gp",
        },
      },
      pairs = {
        enable = true,
        disable = {},
        highlight_pair_events = {},
        highlight_self = false,
        fallback_cmd_normal = "normal! %",
        goto_right_end = false,
        keymaps = {
          goto_partner = "%",
        },
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then return false end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      if opts.rainbow and opts.rainbow.enable then opts.rainbow.strategy = { require "ts-rainbow.strategy.global" } end

      require("nvim-treesitter.configs").setup(opts)

      if load_textobjects then
        -- PERF: no need to load the plugin, if we only need its queries for mini.ai
        if opts.textobjects then
          for _, mod in ipairs { "move", "select", "swap", "lsp_interop" } do
            if opts.textobjects[mod] and opts.textobjects[mod].enable then
              local Loader = require "lazy.core.loader"
              Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
              local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
              require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
              break
            end
          end
        end
      end
    end,
  },
}
