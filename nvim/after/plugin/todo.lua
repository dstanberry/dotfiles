-- verify todo-comments is available
local ok, todo = pcall(require,"todo-comments")
if not ok then
  return
end

todo.setup {
  signs = false,
  sign_priority = 0,
}
