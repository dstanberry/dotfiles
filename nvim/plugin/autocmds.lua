---------------------------------------------------------------
-- => autocmds
---------------------------------------------------------------
local autocmd = {}

function autocmd.nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command("augroup " .. group_name)
    vim.api.nvim_command "autocmd!"
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command "augroup END"
  end
end

local definitions = {
  command = {
    { "CmdLineEnter ", [[set nosmartcase]] },
    { "CmdLineLeave ", [[set smartcase]] },
  },
  ftdetect = {
    { "BufRead,BufNewFile", "*.asc,*.gpg,*.pgp", "setlocal filetype=text" },
    { "BufRead,BufNewFile", "*.vifm", "setlocal filetype=vim" },
    { "BufRead,BufNewFile", "dircolors", "setlocal filetype=sh" },
    { "BufRead,BufNewFile", "gitconfig", "setlocal filetype=.gitconfig" },
    { "BufRead,BufNewFile", "tmux.conf", "setlocal filetype=tmux" },
    { "BufRead,BufNewFile", "vifmrc", "setlocal filetype=vim" },
  },
  ftplugin = {
    { "Filetype", "asc", "setlocal nobackup noswapfile" },
    { "FileType", "bash", "setlocal expandtab shiftwidth=2" },
    { "FileType", "COMMIT_EDITMSG", "setlocal nobackup noswapfile noundofile" },
    { "FileType", "gitcommit", "autocmd! BufEnter COMMIT_EDITMSG call setpos('.',[0, 1, 1, 0])" },
    { "FileType", "gitcommit", "setlocal nofoldenable spell" },
    { "FileType", "gitcommit", "startinsert" },
    { "Filetype", "gpg", "setlocal nobackup noswapfile" },
    { "FileType", "json", "setlocal expandtab shiftwidth=2" },
    { "FileType", "lua", "setlocal expandtab shiftwidth=2" },
    { "Filetype", "pgp", "setlocal nobackup noswapfile" },
    { "FileType", "python", "setlocal expandtab shiftwidth=2" },
    { "FileType", "python", "setlocal expandtab shiftwidth=2" },
    { "FileType", "sh", "setlocal expandtab shiftwidth=2" },
    { "FileType", "sql", "setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 shiftwidth=2 norelativenumber" },
    { "FileType", "vim", "setlocal expandtab shiftwidth=2 foldmethod=marker" },
    { "FileType", "zsh", "setlocal expandtab shiftwidth=2" },
  },
  yank = {
    { "TextYankPost", "*", [[silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=200})]] },
  },
}

autocmd.nvim_create_augroups(definitions)
