local packer = require "util.packer"

local config = {
  profile = {
    enable = false,
    threshold = 0,
  },
  display = {
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
  },
}

local function plugins(use)
  -- package manager
  use { "wbthomason/packer.nvim" }

  -- hacks (until merged/fixed in upstream)
  use { "antoinemadec/FixCursorHold.nvim" }
  use { "nathom/filetype.nvim" }

  -- written in vimscript
  use {
    "wincent/loupe",
    event = "BufRead",
    config = function()
      local c = require("ui.theme").colors
      local groups = require "ui.theme.groups"

      groups.new("IncSearch", { guifg = c.base01, guibg = c.base0A, gui = "none", guisp = nil })

      vim.g.LoupeClearHighlightMap = 0
      vim.g.LoupeVeryMagic = 0
    end,
  }
  use { "duggiefresh/vim-easydir" }
  use { "tpope/vim-repeat" }
  use { "tpope/vim-surround", event = "BufRead" }

  use { "dstein64/vim-startuptime", cmd = "StartupTime", opt = true }
  use { "godlygeek/tabular", cmd = "Tabularize" }
  use { "rrethy/vim-hexokinase", run = "make hexokinase" }
  use { "tpope/vim-scriptease", cmd = { "Messages", "Verbose", "Time" }, opt = true }
  -- syntax highlighting
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
  use { "gisphm/vim-gitignore", ft = "gitignore" }
  use { "mtdl9/vim-log-highlighting", ft = "log" }

  -- filetype specific extensions
  use { "gennaro-tedesco/nvim-jqx", ft = "json" }
  use {
    "npxbr/glow.nvim",
    cmd = "Glow",
    opt = true,
    config = function()
      vim.g.glow_binary_path = ("%s/go/bin"):format(vim.env.XDG_DATA_HOME)
    end,
  }

  -- iconography
  use {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require "remote.devicons"
    end,
  }

  -- builtins
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require "remote.lsp"
      require "remote.lsp.handlers"
    end,
    requires = {
      "folke/lua-dev.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "ray-x/lsp_signature.nvim",
    },
  }
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "p00f/nvim-ts-rainbow",
      "theHamsta/nvim-treesitter-pairs",
      "nvim-treesitter/playground",
    },
    config = function()
      require "remote.treesitter"
    end,
  }

  -- tree-sitter/lsp language support
  use {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    config = function()
      require "remote.lsp.go"
    end,
  }
  use { "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline", requires = { "nvim-lua/plenary.nvim" } }

  -- interface
  use {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opt = true,
    wants = "twilight.nvim",
    requires = { { "folke/twilight.nvim", requires = { "nvim-treesitter/nvim-treesitter" } } },
  }
  use { "jose-elias-alvarez/buftabline.nvim", requires = { "kyazdani42/nvim-web-devicons" } }
  use {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require "notify"
    end,
  }

  -- path and file navigation
  use {
    "tamago324/lir.nvim",
    requires = { "kyazdani42/nvim-web-devicons", "tamago324/lir-git-status.nvim", "tamago324/lir-mmv.nvim" },
  }
  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      require "remote.telescope"
      require "remote.telescope.keymap"
    end,
    requires = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope-github.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
  }

  -- text manipulation
  use {
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      opt = true,
      config = function()
        require "remote.cmp"
      end,
      requires = {
        {
          "L3MON4D3/LuaSnip",
          wants = "friendly-snippets",
          config = function()
            require "remote.luasnip"
            require "remote.luasnip.keymap"
          end,
        },
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
      },
    },
    { "cstrap/python-snippets", opt = true },
    { "honza/vim-snippets", opt = true },
    { "J0rgeSerran0/vscode-csharp-snippets", opt = true },
    { "keyring/vsc-lua", opt = true },
    { "rafamadriz/friendly-snippets", opt = true },
  }
  use { "numToStr/Comment.nvim" }

  -- debug and evaluate code chunks
  use { "bfredl/nvim-luadev", cmd = "Luadev", opt = true }
  use {
    "mfussenegger/nvim-dap",
    opt = true,
    keys = "<localleader>db",
    config = function()
      require "remote.dap"
      require "remote.dap.ui"
      require "remote.dap.keymap"
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
  use { "michaelb/sniprun", run = "bash ./install.sh", cmd = "SnipRun", opt = true }

  -- git integrations
  use { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }
  use { "sindrets/diffview.nvim" }
  use { "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" }

  -- workflow integrations
  use { "aserowy/tmux.nvim" }
end

return packer.setup(config, plugins)
