local util = require "util"

return {
  "olimorris/persisted.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  lazy = false,
  init = function()
    vim.api.nvim_create_augroup("sessionmgr", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = "sessionmgr",
      pattern = "PersistedTelescopeLoadPre",
      callback = function()
        -- stylua: ignore
        vim.schedule(function() vim.cmd "%bd" end)
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = "sessionmgr",
      pattern = "PersistedTelescopeLoadPost",
      callback = function(session)
        vim.notify("Loaded session " .. session.data.name, vim.log.levels.INFO, { title = "persisted.nvim" })
        local path = session.data.dir_path
        if not has "win32" and string.find(path, "/") ~= 1 then
          vim.cmd.cd(vim.fn.expand "~" .. "/" .. path)
          vim.cmd.tcd(vim.fn.expand "~" .. "/" .. path)
        else
          vim.cmd.cd(path)
          vim.cmd.tcd(path)
        end
        -- stylua: ignore
        vim.schedule(function() vim.cmd.edit "%" end)
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
    allowed_dirs = { vim.g.dotfiles, vim.env.hash_notes, vim.g.projects_dir },
    ignored_dirs = { vim.fn.stdpath "data" },
    should_autosave = function()
      local cwd = vim.fn.getcwd()
      if util.contains({ vim.g.dotfiles_dir, vim.env.hash_notes, vim.g.projects_dir }, cwd) then return true end
      return false
    end,
  },
}
