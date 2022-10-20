local util = require "util"

local config = {
  compile_path = vim.fn.stdpath "config" .. "/lua/remote/packer_compiled.lua",
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

  -- startup optimization
  use { "lewis6991/impatient.nvim" }

  -- written in vimscript
  use { "tpope/vim-repeat" }
  -- syntax highlighting
  use { "gisphm/vim-gitignore", ft = "gitignore" }
  use { "mtdl9/vim-log-highlighting", ft = "log" }

  -- filetype specific extensions
  use { "gennaro-tedesco/nvim-jqx", ft = "json" }

  -- iconography
  use {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require "remote.devicons"
    end,
  }

  -- code intelligence
  use {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require "remote.lsp"
      lspconfig.setup()
      lspconfig.handlers.setup()
    end,
    requires = {
      "b0o/schemastore.nvim",
      "folke/neodev.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "jose-elias-alvarez/typescript.nvim",
      "lvimuser/lsp-inlayhints.nvim",
      "mickael-menu/zk-nvim",
      "simrat39/rust-tools.nvim",
      "theHamsta/nvim-semantic-tokens",
    },
  }
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
      "p00f/nvim-ts-rainbow",
      "theHamsta/nvim-treesitter-pairs",
    },
    config = function()
      require "remote.treesitter"
    end,
  }
  use { "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline", requires = { "nvim-lua/plenary.nvim" } }

  -- look-and-feel
  use {
    "folke/noice.nvim",
    event = "VimEnter",
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      local file = vim.api.nvim_get_runtime_file("after/plugin/noice.lua", true)
      vim.cmd.luafile { args = { file } }
    end,
  }
  use { "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" }
  use {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opt = true,
    wants = "twilight.nvim",
    requires = { { "folke/twilight.nvim", requires = { "nvim-treesitter/nvim-treesitter" } } },
  }
  use { "j-hui/fidget.nvim" }
  use { "lukas-reineke/indent-blankline.nvim" }
  use { "NvChad/nvim-colorizer.lua" }
  use { "rcarriga/nvim-notify" }
  use { "SmiteshP/nvim-navic", requires = "neovim/nvim-lspconfig" }

  -- file/path navigation
  use { "akinsho/bufferline.nvim", requires = { "tiagovla/scope.nvim" } }
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
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-github.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
  }
  use { "dstanberry/harpoon" }

  -- text manipulation
  use {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opt = true,
    config = function()
      require "remote.cmp"
    end,
    requires = {
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("remote.luasnip").setup()
          require "remote.luasnip.keymap"
        end,
      },
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
  }
  use { "kylechui/nvim-surround" }
  use { "numToStr/Comment.nvim" }

  -- interactive debugging/REPL
  use { "bfredl/nvim-luadev", cmd = "Luadev", opt = true }
  use {
    "mfussenegger/nvim-dap",
    config = function()
      require("remote.dap").setup()
      require "remote.dap.keymap"
    end,
    requires = {
      "jbyuki/one-small-step-for-vimkind",
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
  }
  use { "michaelb/sniprun", run = "bash ./install.sh", cmd = "SnipRun", opt = true }

  -- git integrations
  use { "akinsho/git-conflict.nvim" }
  use { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }
  use { "ruifm/gitlinker.nvim", requires = "nvim-lua/plenary.nvim" }
  use { "sindrets/diffview.nvim" }
  use { "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" }

  -- workflow/session management
  use { "akinsho/toggleterm.nvim" }
  use { "aserowy/tmux.nvim" }
end

return util.packer.setup(config, plugins)
