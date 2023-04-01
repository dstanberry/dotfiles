local util = require "util"

return {
  "olimorris/persisted.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  event = "BufReadPre",
  init = function()
    vim.opt.sessionoptions = { "buffers", "curdir", "help", "tabpages", "winsize" }
    local sessionmgr = vim.api.nvim_create_augroup("sessionmgr", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = sessionmgr,
      pattern = "PersistedLoadPre",
      callback = function()
        if package.loaded["noice"] then vim.cmd "Noice disable" end
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = sessionmgr,
      pattern = "PersistedTelescopeLoadPre",
      callback = function()
        vim.schedule(function() vim.cmd "%bd" end)
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = sessionmgr,
      pattern = "PersistedLoadPost",
      callback = function()
        if package.loaded["noice"] then vim.cmd "Noice enable" end
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = "sessionmgr",
      pattern = "PersistedTelescopeLoadPost",
      callback = function(session)
        vim.notify("Loaded session " .. session.data.name, vim.log.levels.INFO, { title = "persisted.nvim" })
        local path = session.data.dir_path
        if not has "win32" and string.find(path, "/") ~= 1 then
          vim.cmd.cd(vim.fs.normalize "~" .. "/" .. path)
          vim.cmd.tcd(vim.fs.normalize "~" .. "/" .. path)
        else
          vim.cmd.cd(path)
          vim.cmd.tcd(path)
        end
        vim.schedule(function() vim.cmd.edit "%" end)
      end,
    })
    require("telescope").load_extension "persisted"
    vim.api.nvim_create_user_command("SessionList", function()
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
      if util.contains({ vim.g.dotfiles_dir, vim.env.hash_notes, vim.g.projects_dir }, vim.loop.cwd()) then
        return true
      end
      return false
    end,
  },
}
