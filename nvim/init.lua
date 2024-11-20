if vim.loader then vim.loader.enable() end
vim.g.mapleader = " "
vim.g.maplocalleader = ","

_G.ds = require "util"

vim.cmd.colorscheme "kdark"

ds.fs.load_settings()

ds.plugin.setup {
  autocmds = function()
    local group = ds.augroup "lazy"

    vim.api.nvim_create_autocmd("BufReadPost", {
      once = true,
      callback = function(args)
        if vim.v.vim_did_enter == 1 then return end
        local ft = vim.filetype.match { buf = args.buf }
        if ft then
          local lang = vim.treesitter.language.get_lang(ft)
          if not (lang and pcall(vim.treesitter.start, args.buf, lang)) then vim.bo[args.buf].syntax = ft end
          vim.cmd [[redraw]]
        end
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "VeryLazy",
      callback = function()
        ds.fs.load_dirhash(vim.env.SHELL)
        ds.root.setup()
        ds.color.sync_term_bg()

        vim.g.dotfiles_dir = vim.fs.joinpath(vim.env.HOME, ".config")
        vim.g.projects_dir = vim.env.projects_dir and vim.fs.normalize(vim.env.projects_dir)
          or vim.fs.joinpath(vim.env.HOME, "Projects")

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
                return vim.bo[buf] ~= "bigfile" and path and vim.fn.getfsize(path) > 1024 * 1024 * 1.5 and "bigfile"
                  or nil
              end,
            },
          },
        }
      end,
    })
  end,
}
