local stash = require "remote.snacks.stash"

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = function()
      local copy = stash.gitbrowse.copy_url
      local lazy_rtp = vim.fs.joinpath(vim.fn.stdpath "data", "lazy")
      local nvim_conf = tostring(vim.fn.stdpath "config")
      local function ll(key) return "<localleader>" .. key end

      return {
        -- lsp
        { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "lsp: goto next reference" },
        { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "lsp: goto prev reference" },
        { ll "fl", function() Snacks.picker.lsp_config() end, desc = "lsp: show config" },
        -- files
        { "<leader><leader>", function() Snacks.picker.files() end, desc = "picker: find files" },
        { "<leader>f;", function() Snacks.picker.command_history() end, desc = "picker: find in command history" },
        { "<leader>f/", function() Snacks.picker.registers() end, desc = "picker: find in register" },
        { "<leader>fb", function() Snacks.picker.grep_buffers() end, desc = "picker: find in buffers (grep)" },
        { "<leader>fB", function() Snacks.picker.buffers() end, desc = "picker: find files (buffers)" },
        -- stylua: ignore
        { "<leader>fe", function() stash.picker.file_explorer { follow_file = true } end, desc = "picker: toggle explorer" },
        { "<leader>fk", function() Snacks.picker.help() end, desc = "picker: help pages" },
        { "<leader>fl", function() Snacks.picker.lazy() end, desc = "picker: find plugin specs" },
        { "<leader>fp", function() Snacks.picker.files { cwd = lazy_rtp } end, desc = "picker: find remote plugins" },
        { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "picker: find todo comments" },
        { "<leader>fz", function() Snacks.picker.spelling() end, desc = "picker: spelling suggestions" },
        { ll "<leader>", function() Snacks.picker.files { cwd = nvim_conf } end, desc = "picker: find config files" },
        { ll "fe", function() stash.picker.file_browser() end, desc = "picker: find relative files" },
        { ll "fg", function() Snacks.picker.grep() end, desc = "picker: find in files (grep)" },
        -- git(hub)
        { "<leader>gd", function() stash.picker.git_diff_tree() end, desc = "git: diff tree" },
        { "<leader>gf", function() Snacks.picker.git_status() end, desc = "git: show changed files" },
        { "<leader>gg", function() Snacks.lazygit.open() end, desc = "git: lazygit" },
        { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "github: find issues (open)" },
        { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "github: find pull requests (open)" },
        { "<leader>gl", function() Snacks.lazygit.log_file() end, desc = "git: lazygit log" },
        { ll "gl", function() Snacks.picker.git_log() end, desc = "git: log (pickaxe)" },
        { ll "go", function() Snacks.gitbrowse.open() end, desc = "git: open in browser", mode = { "n", "v" } },
        { ll "gy", function() Snacks.gitbrowse.open(copy) end, desc = "git: copy remote url", mode = { "n", "v" } },
        -- window
        { "<leader>wn", function() Snacks.notifier.show_history() end, desc = "messages: show notifications" },
        { "<leader>ws", function() stash.scratch.select() end, desc = "notes: select scratchpad" },
        { "<leader>wt", function() Snacks.terminal.toggle() end, desc = "terminal: toggle split" },
        { "<leader>wz", function() Snacks.zen.zen() end, desc = "zen: toggle window" },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        group = ds.augroup "remote.snacks",
        pattern = "VeryLazy",
        callback = stash.util.setup,
      })
    end,
    opts = function()
      return { ---@type snacks.Config
        -- buffer/window options
        styles = stash.styles,
        -- no config
        bigfile = { enabled = true },
        explorer = { replace_netrw = true },
        quickfile = { enabled = true },
        scroll = { enabled = true },
        words = { enabled = true },
        -- low config
        image = { force = not (ds.has "win32" or ds.has "wsl"), doc = { inline = false } },
        notifier = { style = "fancy", gap = 1, margin = { top = 1, right = 1, bottom = 2 } },
        input = { win = { keys = { i_jk = { "jk", { "cmp_close", "cancel" }, mode = "i" } } } },
        -- non-trivial config
        gitbrowse = stash.gitbrowse.config,
        dashboard = stash.dashboard.config,
        indent = stash.indent.config,
        lazygit = stash.lazygit.config,
        picker = stash.picker.config,
      }
    end,
    config = function(_, opts)
      local snacks = require "snacks"

      snacks.setup(opts)
      vim.lsp.handlers["callHierarchy/incomingCalls"] = snacks.picker.lsp_incoming_calls
      vim.lsp.handlers["callHierarchy/outgoingCalls"] = snacks.picker.lsp_outgoing_calls
      vim.lsp.handlers["textDocument/documentSymbol"] = snacks.picker.lsp_symbols
      vim.lsp.handlers["workspace/symbol"] = snacks.picker.lsp_workspace_symbols
    end,
  },
}
