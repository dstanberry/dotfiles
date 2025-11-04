if vim.loader then vim.loader.enable() end

vim.g.health = { style = "float" }
vim.g.mapleader = " "
vim.g.maplocalleader = ","

if vim.env.VSCODE then vim.g.vscode = true end
vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(vim.env.HOME, ".config")

_G.ds = require "util"
ds.env.load_settings()

vim.cmd.colorscheme(ds.env "theme" or "kdark")

ds.plugin.setup {
  on_init = function()
    ds.fs.load_dirhash(vim.env.SHELL)
    ds.root.setup()
    ds.ui.virtcolumn()
    ds.color.sync_term_bg()

    if vim.env.GH_FORCE_TTY then vim.env.GH_FORCE_TTY = nil end
    if ds.env "github_hostname" then vim.env.GH_HOST = ds.env "github_hostname" end

    vim.g.dotfiles_dir = vim.env.XDG_CONFIG_HOME
    vim.g.projects_dir = vim.env.projects_dir and vim.fs.normalize(vim.env.projects_dir)
      or vim.fs.joinpath(vim.env.HOME, "Projects")

    for _, dir in ipairs { "backup", "shada", "swap", "undo" } do
      vim.fn.mkdir(vim.fs.joinpath(vim.fn.stdpath "cache", dir), "p")
    end

    vim.o.clipboard = "unnamedplus"
    if ds.has "wsl" then
      -- NOTE: May require `Beta: Use Unicode UTF-8 for global language support`
      -- https://github.com/microsoft/WSL/issues/4852
      vim.g.clipboard = { -- use win32 native clipboard tool on WSL
        name = "WslClipboard",
        copy = {
          ["+"] = "clip.exe",
          ["*"] = "clip.exe",
        },
        paste = {
          ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
          ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
      }
    end

    vim.filetype.add {
      extension = {
        jenkinsfile = "groovy",
        json = "jsonc",
        mdx = "markdown.mdx",
        tf = "terraform",
        vifm = "vim",
        vifmrc = "vim",
      },
      filename = {
        [".env"] = "sh",
        [".flake8"] = "toml",
        ["tmux.conf"] = "tmux",
        Brewfile = "ruby",
        jenkinsfile = "groovy",
      },
      pattern = {
        ["%.env%.[%w_.-]+"] = "sh",
        [".*/git/config"] = "gitconfig",
        [".*/git/gitconfig"] = "gitconfig",
        [".*/git/ignore"] = "gitignore",
        ["requirements[%w_.-]+%.txt"] = "requirements",
        [".*%.y[a]ml"] = function(path, _)
          local root = vim.fs.find({ "Chart.yaml", "Chart.yml" }, { path = path, upward = true })[1]
          return root and "helm" or "yaml"
        end,
        config = function(path, bufnr)
          if not vim.api.nvim_buf_is_valid(bufnr) then return vim.bo[bufnr].filetype or "config" end
          local sibling = vim.fs.find({ "HEAD", "FETCH_HEAD" }, { path = path, upward = true, limit = 2 })
          return #sibling == 2 and "gitconfig" or "config"
        end,
      },
    }
  end,
}
