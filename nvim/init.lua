if vim.loader then vim.loader.enable() end

vim.g.mapleader = " "
vim.g.maplocalleader = ","

_G.ds = require "util"

vim.print = ds.inspect

vim.cmd.colorscheme "kdark"

ds.fs.load_settings()
ds.plugin.setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    ds.fs.load_dirhash(vim.env.SHELL)
    ds.root.setup()
    ds.color.sync_term_bg()

    vim.g.dotfiles_dir = vim.fs.joinpath(vim.env.HOME, ".config")
    vim.g.projects_dir = vim.env.projects_dir and vim.fs.normalize(vim.env.projects_dir)
      or vim.fs.joinpath(vim.env.HOME, "Projects")

    vim.filetype.add {
      extension = {
        jenkinsfile = "groovy",
        json = "jsonc",
        mdx = "markdown.mdx",
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
        [".*/kitty/.+%.conf"] = "bash",
        [".*"] = {
          function(path, buf)
            return vim.bo[buf] ~= "bigfile" and path and vim.fn.getfsize(path) > 1024 * 1024 * 1.5 and "bigfile" or nil
          end,
        },
      },
    }
  end,
})
