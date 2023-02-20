local lazypath = string.format("%s/lazy/lazy.nvim", vim.fn.stdpath "data")
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_create_augroup("lazy-buffer", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "lazy-buffer",
  pattern = "lazy",
  callback = function()
    -- force |BufEnter| so that statusline formatting applies
    vim.cmd.doautocmd "BufEnter"
  end,
})

local opts = {
  root = string.format("%s/lazy", vim.fn.stdpath "data"),
  lockfile = string.format("%s/lua/remote/lazy-lock.json", vim.fn.stdpath "config"),
  ui = {
    border = "none",
  },
}

local plugins = {
  -- package manager
  {
    "williamboman/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
    },
  },
  {
    "jayp0521/mason-null-ls.nvim",
    config = function()
      require("mason-null-ls").setup {
        automatic_installation = true,
      }
    end,
  },
  -- startup optimization
  { "lewis6991/impatient.nvim" },
  -- written in vimscript
  { "tpope/vim-repeat" },
  -- filetype extensions
  { "gennaro-tedesco/nvim-jqx", ft = "json" },
  { "mtdl9/vim-log-highlighting", ft = "log" },
  -- iconography
  {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require "remote.devicons"
    end,
  },
  -- file/path navigation
  { "akinsho/bufferline.nvim", dependencies = { "tiagovla/scope.nvim" } },
  {
    "tamago324/lir.nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      "tamago324/lir-git-status.nvim",
      "tamago324/lir-mmv.nvim",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require "remote.telescope"
      require "remote.telescope.keymap"
    end,
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-github.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
  { "dstanberry/harpoon" },
  -- code intelligence
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require "remote.lsp"
      lspconfig.setup()
      lspconfig.handlers.setup()
    end,
    dependencies = {
      "b0o/schemastore.nvim",
      "folke/neodev.nvim",
      {
        "folke/neoconf.nvim",
        cmd = { "Neoconf" },
        opts = { local_settings = ".nvim.json", global_settings = "nvim.json" },
        config = function()
          require("neoconf").setup {}
        end,
      },
      "jose-elias-alvarez/null-ls.nvim",
      "jose-elias-alvarez/typescript.nvim",
      "lvimuser/lsp-inlayhints.nvim",
      "simrat39/rust-tools.nvim",
      "theHamsta/nvim-semantic-tokens",
      { "mickael-menu/zk-nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require "remote.treesitter"
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          require "remote.treesitter.context"
        end,
      },
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
      "p00f/nvim-ts-rainbow",
      "theHamsta/nvim-treesitter-pairs",
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- look-and-feel
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    lazy = true,
    dependencies = { "folke/twilight.nvim" },
  },
  { "j-hui/fidget.nvim" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "NvChad/nvim-colorizer.lua" },
  { "rcarriga/nvim-notify" },
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require "remote.navic"
    end,
  },
  -- text manipulation
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    lazy = true,
    config = function()
      require "remote.cmp"
    end,
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("remote.luasnip").setup()
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
  },
  { "kylechui/nvim-surround" },
  { "numToStr/Comment.nvim" },
  -- interactive debugging/REPL
  { "bfredl/nvim-luadev", cmd = "Luadev", lazy = true },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      require("remote.dap").setup()
      -- require "remote.dap.keymap"
    end,
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
      },
      "jbyuki/one-small-step-for-vimkind",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
  },
  { "michaelb/sniprun", build = "bash ./install.sh", cmd = "SnipRun", lazy = true },
  -- git integrations
  { "akinsho/git-conflict.nvim" },
  { "lewis6991/gitsigns.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "ruifm/gitlinker.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "sindrets/diffview.nvim" },
  { "TimUntersberger/neogit", dependencies = { "nvim-lua/plenary.nvim" } },
  -- workflow/session management
  { "akinsho/toggleterm.nvim" },
  { "aserowy/tmux.nvim" },
}

require("lazy").setup(plugins, opts)
