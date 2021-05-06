---------------------------------------------------------------
-- => vim-language-server configuration
---------------------------------------------------------------
return {
  cmd = {"vim-language-server", "--stdio"},
  filetypes = {"vim"},
  init_options = {
    diagnostic = {enable = true},
    indexes = {
      count = 3,
      gap = 100,
      projectRootPatterns = {
        ".git", "autoload", "nvim", "plugin", "runtime", "vim"
      },
      runtimepath = true
    },
    iskeyword = "@,48-57,_,192-255,-#",
    runtimepath = "",
    suggest = {fromRuntimepath = true, fromVimruntime = true},
    vimruntime = ""
  }
}
