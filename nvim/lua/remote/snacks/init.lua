local res = require "remote.snacks.res"

return {
  {
    "folke/snacks.nvim",
    url = "https://github.com/dstanberry/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = function()
      local copy = res.gitbrowse.copy_url
      local lazy_rtp = vim.fs.joinpath(vim.fn.stdpath "data", "lazy")
      local nvim_path = tostring(vim.fn.stdpath "config")
      -- stylua: ignore
      return {
        -- lsp
        { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "lsp: goto next reference" },
        { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "lsp: goto prev reference" },
        { "<localleader>fl", function() Snacks.picker.lsp_config() end, desc = "lsp: show config" },
        -- files
        { "<leader><leader>", function() Snacks.picker.files() end, desc = "picker: find files" },
        { "<leader>f;", function() Snacks.picker.command_history() end, desc = "picker: find word (last searched)" },
        { "<leader>f/", function() Snacks.picker.registers() end, desc = "picker: find word (last searched)" },
        { "<leader>fb", function() Snacks.picker.grep_buffers() end, desc = "picker: find in buffers (grep)" },
        { "<leader>fB", function() Snacks.picker.buffers() end, desc = "picker: find files (buffers)" },
        { "<leader>fe", function() Snacks.picker.explorer { follow_file = true } end, desc = "picker: find files (buffers)" },
        { "<leader>fk", function() Snacks.picker.help() end, desc = "picker: help pages" },
        { "<leader>fl", function() Snacks.picker.lazy() end, desc = "picker: find plugin specs" },
        { "<leader>fp", function () Snacks.picker.files { cwd = lazy_rtp } end, desc = "picker: find remote plugins" },
        { "<leader>ft", function () Snacks.picker.todo_comments() end, desc = "picker: find todo comments" },
        { "<leader>fz", function () Snacks.picker.spelling() end, desc = "picker: spelling suggestions" },
        { "<localleader><leader>", function() Snacks.picker.files { cwd = nvim_path } end, desc = "picker: find config files" },
        { "<localleader>fe", function() res.picker.file_browser() end, desc = "picker: find files (relative to current buffer)" },
        { "<localleader>fg", function() Snacks.picker.grep() end, desc = "picker: find in files (grep)" },
        -- git
        { "<leader>gd", function() res.picker.git_diff_tree() end, desc = "git: diff tree" },
        { "<leader>gf", function() Snacks.picker.git_status() end, desc = "git: show changed files" },
        { "<leader>gg", function() Snacks.lazygit.open() end, desc = "git: lazygit" },
        { "<leader>gl", function() Snacks.lazygit.log_file() end, desc = "git: lazygit log" },
        { "<localleader>go", function() Snacks.gitbrowse.open() end, desc = "git: open in browser", mode = { "n", "v" } },
        { "<localleader>gy", function() Snacks.gitbrowse.open(copy) end, desc = "git: copy remote url", mode = { "n", "v" } },
        -- window
        { "<leader>wn", function() Snacks.notifier.show_history() end, desc = "messages: show notifications" },
        { "<leader>ws", function() res.scratch.select() end, desc = "notes: select scratchpad" },
        { "<leader>wt", function() Snacks.terminal.toggle() end, desc = "terminal: toggle split" },
        { "<leader>wz", function() Snacks.zen.zen() end, desc = "zen: toggle window" },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        group = ds.augroup "snacks",
        pattern = "VeryLazy",
        callback = res.notify.setup,
      })
    end,
    opts = function()
      return { ---@type snacks.Config
        -- buffer/window options
        styles = res.styles,
        -- plugins using default config
        bigfile = { enabled = true },
        explorer = { replace_netrw = true },
        gitbrowse = res.gitbrowse.config,
        image = { force = not (ds.has "win32" or ds.has "wsl"), doc = { inline = false } },
        notifier = { style = "compact", margin = { top = 1, right = 1, bottom = 2 } },
        quickfile = { enabled = true },
        scroll = { enabled = true },
        words = { enabled = true },
        -- plugins with custom config
        dashboard = res.dashboard.config,
        indent = res.indent.config,
        input = { win = { keys = { i_jk = { "jk", { "cmp_close", "cancel" }, mode = "i" } } } },
        lazygit = res.lazygit.config,
        picker = res.picker.config(),
      }
    end,
    config = function(_, opts)
      local snacks = require "snacks"

      snacks.setup(opts)
      vim.lsp.handlers["textDocument/documentSymbol"] = snacks.picker.lsp_symbols
      vim.lsp.handlers["workspace/symbol"] = snacks.picker.lsp_workspace_symbols
    end,
  },
}
