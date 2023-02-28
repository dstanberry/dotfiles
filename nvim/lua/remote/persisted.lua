return {
  "olimorris/persisted.nvim",
  lazy = false,
  dependencies = { "nvim-telescope/telescope.nvim" },
  init = function()
    vim.api.nvim_create_augroup("sessionmgr", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = "sessionmgr",
      pattern = "PersistedTelescopePre",
      callback = function()
        -- stylua: ignore
        vim.schedule(function() vim.cmd "%bd" end)
      end,
    })
    require("telescope").load_extension "persisted"
    vim.api.nvim_create_user_command("ListSessions", function()
      local themes = require "telescope.themes"
      require("telescope").extensions.persisted.persisted(themes.get_dropdown {
        previewer = false,
        prompt_title = "Available Sessions",
      })
    end, {})
  end,
  config = {
    autoload = true,
    use_git_branch = true,
    should_autosave = true,
    allowed_dirs = { vim.g.dotfiles, vim.g.work_dir },
    ignored_dirs = { vim.fn.stdpath "data" },
  },
}
