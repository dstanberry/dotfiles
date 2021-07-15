---------------------------------------------------------------
-- => Plugin Manager
---------------------------------------------------------------
-- plugin configuration
return require("packer").startup(function(use)
  -- package manager for neovim
  use "wbthomason/packer.nvim"

  -- fix cursorhold events
  use { "antoinemadec/FixCursorHold.nvim" }
  -- emphasize the current matched search pattern
  use "wincent/loupe"
  -- preview/browse json files with ease
  use { "gennaro-tedesco/nvim-jqx", opt = true, ft = "json" }
  -- easy text alignment
  use "godlygeek/tabular"
  -- file-type aware comments
  use "tpope/vim-commentary"
  -- create file and parent direcory at the same time
  use "duggiefresh/vim-easydir"
  -- color highlighter
  use { "rrethy/vim-hexokinase", run = "make hexokinase" }
  -- syntax highlighting for log files
  use { "mtdl9/vim-log-highlighting", opt = true, ft = "log" }
  -- enable repeating actions with <.>
  use "tpope/vim-repeat"
  -- debug vim plugins
  use { "tpope/vim-scriptease", opt = true, cmd = { "Messages", "Verbose", "Time" } }
  -- better profiling of startup time.
  use { "dstein64/vim-startuptime", opt = true, cmd = "StartupTime" }
  -- surround sequence with tags
  use "tpope/vim-surround"
  -- enable focus events
  use "tmux-plugins/vim-tmux-focus-events"

  -- syntax highlighting for portage
  if vim.fn.isdirectory "/etc/portage" then
    use {
      "gentoo/gentoo-syntax",
      opt = true,
      ft = {
        "gentoo-changelog",
        "gentoo-conf-d",
        "gentoo-env-d",
        "gentoo-init-d",
        "gentoo-make-conf",
        "gentoo-metadata",
        "gentoo-package-keywords",
        "gentoo-package-license",
        "gentoo-package-make",
        "gentoo-package-properties",
        "gentoo-package-use",
        "gentoo-use-desc",
      },
    }
  end
  -- better syntax highlighting for json
  use { "elzr/vim-json", ft = "json", opt = true }
  -- syntax highlighting for powershell scripts
  use { "PProvost/vim-ps1", ft = "ps1", opt = true }
  -- syntax highlighting for c, bison and flex
  use { "justinmk/vim-syntax-extra", ft = "c", opt = true }

  -- devicons (requires patched font)
  use "kyazdani42/nvim-web-devicons"
  -- minimalist file explorer
  use { "tamago324/lir.nvim", requires = { "kyazdani42/nvim-web-devicons" } }
  -- minimalist tabline
  use { "jose-elias-alvarez/buftabline.nvim", requires = { "kyazdani42/nvim-web-devicons" } }
  -- incremental parsing system for programming tools

  use {
    "nvim-treesitter/nvim-treesitter",
    opt = true,
    event = "BufRead",
    run = ":TSUpdate",
    requires = {
      -- view treesitter information directly
      { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
      -- pairs
      "theHamsta/nvim-treesitter-pairs",
      -- highlight and manipulate text objects
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- refactor text objects
      "nvim-treesitter/nvim-treesitter-refactor",
      -- easily identify nested parentheses
      "p00f/nvim-ts-rainbow",
    },
    config = function()
      require "remote.treesitter"
      require "remote.treesitter.parsers"
    end,
  }
  -- distraction-free coding
  use {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opt = true,
    wants = "twilight.nvim",
    requires = {
      -- dim inactive portions of text using treesitter
      { "folke/twilight.nvim", requires = { "nvim-treesitter/nvim-treesitter" } },
    },
  }

  -- framework for setting up language servers
  use {
    "neovim/nvim-lspconfig",
    wants = { "lsp_signature.nvim", "lua-dev" },
    config = function()
      require "remote.lsp"
    end,
    requires = {
      -- integrate lua LSP API
      "folke/lua-dev.nvim",
      -- show signature hint while typing
      "ray-x/lsp_signature.nvim",
    },
  }
  -- lsp driven tree view for symbols
  use { "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline", requires = { "nvim-lua/plenary.nvim" } }

  -- modular fuzzy finder
  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      require "remote.telescope"
      require "remote.telescope.keymap"
    end,
    wants = {
      "plenary.nvim",
      "popup.nvim",
      "telescope-fzy-native.nvim",
      "telescope-fzf-native.nvim",
      "telescope-project.nvim",
      "telescope-symbols.nvim",
      "telescope-lsp-handlers.nvim",
    },
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      -- pick and insert symbols
      "nvim-telescope/telescope-symbols.nvim",
      -- pre-compiled c port of fzf
      "nvim-telescope/telescope-fzf-native.nvim",
      -- pre-compiled fzy sorter
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      -- Telescope extension for LSP
      "gbrlsnchs/telescope-lsp-handlers.nvim",
    },
  }

  -- auto completion framework
  use {
    "hrsh7th/nvim-compe",
    event = "InsertEnter",
    opt = true,
    config = function()
      require "remote.compe"
      require "remote.compe.keymap"
      require "remote.compe.menu"
    end,
    wants = { "LuaSnip" },
    requires = {
      {
        -- snippet engine
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        config = function()
          require "remote.luasnip"
        end,
      },
      -- snippet support
      "rafamadriz/friendly-snippets",
      "cstrap/python-snippets",
      "keyring/vsc-lua",
      "honza/vim-snippets",
      "J0rgeSerran0/vscode-csharp-snippets",
    },
  }

  -- debug adapter protocol client implementation
  use {
    "mfussenegger/nvim-dap",
    wants = {
      "nvim-dap-virtual-text",
      "nvim-dap-python",
      "one-small-step-for-vimkind",
    },
    requires = {
      -- add virtual text support for nvim-dap
      "theHamsta/nvim-dap-virtual-text",
      -- dap extension for python
      "mfussenegger/nvim-dap-python",
      -- debug adapter for plugins
      "jbyuki/one-small-step-for-vimkind",
    },
  }

  -- display git changes in gutter
  use {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    wants = "plenary.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  }
  -- text based user interface to git
  use { "TimUntersberger/neogit", cmd = "Neogit", requires = "nvim-lua/plenary.nvim" }

  -- preview markdown directly
  use({ "npxbr/glow.nvim", cmd = "Glow" })
end)
