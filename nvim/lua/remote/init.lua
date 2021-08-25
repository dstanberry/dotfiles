---------------------------------------------------------------
-- => Plugin Manager
---------------------------------------------------------------
return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  use { "antoinemadec/FixCursorHold.nvim" }
  use {
    "wincent/loupe",
    config = function()
      vim.g.LoupeClearHighlightMap = 0
      vim.g.LoupeVeryMagic = 0
    end,
  }
  use "duggiefresh/vim-easydir"
  use "tpope/vim-commentary"
  use "tpope/vim-repeat"
  use "tpope/vim-surround"
  use { "dstein64/vim-startuptime", opt = true, cmd = "StartupTime" }
  use { "godlygeek/tabular", cmd = "Tabularize" }
  use { "rrethy/vim-hexokinase", run = "make hexokinase" }
  use { "tpope/vim-scriptease", opt = true, cmd = { "Messages", "Verbose", "Time" } }

  if vim.fn.isdirectory "/etc/portage" then
    use {
      "gentoo/gentoo-syntax",
      ft = {
        "ebuild",
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
  use { "gennaro-tedesco/nvim-jqx", ft = "json" }
  use { "gisphm/vim-gitignore", ft = "gitignore" }
  use { "mtdl9/vim-log-highlighting", ft = "log" }

  use { "npxbr/glow.nvim", cmd = "Glow" }

  use "tjdevries/astronauta.nvim"

  use {
    "yamatsum/nvim-nonicons",
    requires = {
      {
        "kyazdani42/nvim-web-devicons",
        config = function()
          require "remote.devicons"
        end,
      },
    },
  }
  use {
    "tamago324/lir.nvim",
    wants = { "tamago324/lir-git-status.nvim", "tamago324/lir-mmv.nvim" },
    requires = { "kyazdani42/nvim-web-devicons", "tamago324/lir-git-status.nvim", "tamago324/lir-mmv.nvim" },
  }
  use { "jose-elias-alvarez/buftabline.nvim", requires = { "kyazdani42/nvim-web-devicons" } }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "p00f/nvim-ts-rainbow",
      "theHamsta/nvim-treesitter-pairs",
      { "nvim-treesitter/playground", cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" } },
    },
    config = function()
      require "remote.treesitter"
    end,
  }
  use {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opt = true,
    wants = "twilight.nvim",
    requires = {
      { "folke/twilight.nvim", requires = { "nvim-treesitter/nvim-treesitter" } },
    },
  }

  use {
    "neovim/nvim-lspconfig",
    wants = { "lsp_signature.nvim", "lua-dev" },
    config = function()
      require "remote.lsp"
    end,
    requires = {
      "folke/lua-dev.nvim",
      "ray-x/lsp_signature.nvim",
    },
  }
  use { "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline", requires = { "nvim-lua/plenary.nvim" } }

  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      require "remote.telescope"
      require "remote.telescope.keymap"
      require "remote.telescope.handlers"
    end,
    wants = {
      "plenary.nvim",
      "popup.nvim",
      "telescope-fzf-native.nvim",
      "telescope-project.nvim",
      "telescope-symbols.nvim",
    },
    requires = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
  }

  use {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opt = true,
    config = function()
      require "remote.cmp"
    end,
    wants = { "LuaSnip" },
    requires = {
      {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        config = function()
          require "remote.luasnip"
        end,
      },
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      "cstrap/python-snippets",
      "honza/vim-snippets",
      "J0rgeSerran0/vscode-csharp-snippets",
      "keyring/vsc-lua",
      "rafamadriz/friendly-snippets",
    },
  }

  use { "bfredl/nvim-luadev", opt = true, cmd = "Luadev" }
  use {
    "rhysd/git-messenger.vim",
    keys = "<leader>gm",
    config = function()
      vim.g.git_messenger_floating_win_opts = { border = "single" }
    end,
  }
  use {
    "mfussenegger/nvim-dap",
    opt = true,
    keys = "<localleader>db",
    config = function()
      require "remote.dap"
    end,
    wants = {
      "nvim-dap-python",
      "nvim-dap-ui",
      "nvim-dap-virtual-text",
      "one-small-step-for-vimkind",
    },
    requires = {
      "jbyuki/one-small-step-for-vimkind",
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
  }

  use { "sindrets/diffview.nvim", opt = true, cmd = "DiffviewOpen" }
  use {
    "lewis6991/gitsigns.nvim",
    wants = "plenary.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  }
  use { "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" }

  use { "michaelb/sniprun", run = "bash ./install.sh", opt = true, cmd = "SnipRun" }

  use {
    "tversteeg/registers.nvim",
    config = function()
      vim.g.registers_hide_only_whitespace = 1
      vim.g.registers_show_empty_registers = 0
      vim.g.registers_trim_whitespace = 1
      vim.g.registers_window_border = "rounded"
    end,
  }
  use "aserowy/tmux.nvim"

  use {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require "notify"
    end,
  }
end)
