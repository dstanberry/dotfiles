---------------------------------------------------------------
-- => Plugin Manager
---------------------------------------------------------------
-- forcibly load vim-vsnip
vim.cmd [[packadd vim-vsnip]]

return require("packer").startup(function(use)
  -- package manager for neovim
  use "wbthomason/packer.nvim"

  -- fix cursorhold events
  use {
    "antoinemadec/FixCursorHold.nvim",
    run = function()
      vim.g.curshold_updatime = 1000
    end,
  }
  -- distraction-free writing
  use "junegunn/goyo.vim"
  -- hyperfocus-writing
  use "junegunn/limelight.vim"
  -- emphasize the current matched search pattern
  use "wincent/loupe"
  -- preview/browse json files with ease
  use "gennaro-tedesco/nvim-jqx"
  -- easy text alignment
  use "godlygeek/tabular"
  -- file-type aware comments
  use "tpope/vim-commentary"
  -- fast and minimalist file explorer
  use "justinmk/vim-dirvish"
  -- create file and parent direcory at the same time
  use "duggiefresh/vim-easydir"
  -- a git wrapper for vim
  use "tpope/vim-fugitive"
  -- color highlighter
  use { "rrethy/vim-hexokinase", run = "make hexokinase" }
  -- highlight sets of matching keywords
  use "andymass/vim-matchup"
  -- enable repeating actions with <.>
  use "tpope/vim-repeat"
  -- display git changes in gutter
  use "mhinz/vim-signify"
  -- start screen
  use "mhinz/vim-startify"
  -- better profiling of startup time.
  use {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  }
  -- surround sequence with tags
  use "tpope/vim-surround"
  -- enable focus events
  use "tmux-plugins/vim-tmux-focus-events"

  -- syntax highlighting for portage
  if vim.fn.isdirectory "/etc/portage" then
    use "gentoo/gentoo-syntax"
  end
  -- better syntax highlighting for json
  use { "elzr/vim-json", ft = "json" }
  -- syntax highlighting for powershell scripts
  use { "PProvost/vim-ps1", ft = "ps1" }
  -- syntax highlighting for c, bison and flex
  use { "justinmk/vim-syntax-extra", ft = "c" }

  -- devicons (requires patched font)
  use "kyazdani42/nvim-web-devicons"
  -- minimalist file explorer
  use "tamago324/lir.nvim"

  -- parser generator tool
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use "nvim-treesitter/nvim-treesitter-textobjects"
  -- easily identify nested parentheses
  use "p00f/nvim-ts-rainbow"

  -- framework for setting up language servers
  use "neovim/nvim-lspconfig"
  -- centralize installation of lua-language-server (sumneko)
  use "tjdevries/nlua.nvim"

  -- modular fuzzy finder
  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
  }
  -- pre-compiled fzy sorter
  use "nvim-telescope/telescope-fzy-native.nvim"
  -- pre-compiled c port of fzf
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
  -- Telescope extension for LSP
  use "gbrlsnchs/telescope-lsp-handlers.nvim"

  -- auto completion framework
  use {
    "hrsh7th/nvim-compe",
    requires = {
      { "hrsh7th/vim-vsnip", opt = true },
      { "hrsh7th/vim-vsnip-integ", opt = true },
    },
  }
  -- extension for completion menu
  use "tjdevries/complextras.nvim"
  -- snippet support
  use "rafamadriz/friendly-snippets"
  use "cstrap/python-snippets"
  use "keyring/vsc-lua"
  use "honza/vim-snippets"
  use "J0rgeSerran0/vscode-csharp-snippets"

  -- debug adapter protocol client implementation
  use "mfussenegger/nvim-dap"
  -- add virtual text support for nvim-dap
  use "theHamsta/nvim-dap-virtual-text"
  -- debug adapter for plugins
  use "jbyuki/one-small-step-for-vimkind"
  -- dap extension for python
  use "mfussenegger/nvim-dap-python"
end)
