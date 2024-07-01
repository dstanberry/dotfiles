---@class util.icons
local M = {}
M.border = {
  Compact = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
  Default = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
}

M.diagnostics = {
  Error = "",
  Hint = "",
  Info = "",
  Warn = "",
}

M.debug = {
  Breakpoint = "",
  BreakpointActive = "",
  Bug = "",
  Continue = "",
  Disconnect = "",
  Pause = "",
  Restart = "",
  Start = "",
  StepInto = "",
  StepOut = "",
  StepOver = "",
  StepBack = "",
  Stop = "",
  REPL = "",
  Scopes = "",
  Stacks = "",
  Watches = "",
}

M.documents = {
  File = "",
  Files = "",
  MultipleFolders = "󰉓",
  FolderClosed = "󰉋",
  FolderEmpty = "󱞞",
  FolderOpened = "󰝰",
  FolderOutlineClosed = "",
  FolderOutlineOpened = "",
}

M.git = {
  Branch = "",
  Commit = "",
  Compare = "",
  Development = "󰊢",
  Issue = "",
  Merge = "",
  PullRequest = "",
  TextAdded = "",
  TextChanged = "",
  TextRemoved = "",
}

M.groups = {
  Book = "",
  Diff = "",
  Lab = "",
  Pinned = "",
  Sql = "",
  StackFrame = "",
  Tree = "󰙅",
}

M.kind = {
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Copilot = " ",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "󰊕",
  Interface = "",
  Keyword = "󰌆",
  Method = "󰊕",
  Module = "",
  Namespace = "󰦮",
  Operator = "",
  Property = "",
  Reference = "",
  Snippet = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
}

M.markdown = {
  Checked = "󰄲  ",
  Unchecked = "󰄱  ",
  H1 = "▓",
  H2 = "▓▓",
  H3 = "▓▓▓",
  H4 = "▓▓▓▓",
  H5 = "▓▓▓▓▓",
  H6 = "▓▓▓▓▓▓",
  ListMinus = "•",
}

M.misc = {
  ArrowSwap = " ",
  Calendar = "",
  CaretRight = "",
  CheckFilled = "",
  ChevronRight = "›",
  Circle = "",
  CircleDot = "•",
  Clipboard = "󰅍",
  Close = "",
  CloseBold = "",
  DiagonalExpand = "",
  DiagonalShrink = "󰘕",
  DownArrow = "↓",
  Ellipses = "⋯",
  FilledCircle = "●",
  FoldClosed = "",
  FoldOpened = "",
  Gears = "",
  HalfBlockLower = "▃",
  HalfBlockUpper = "▀",
  Key = "",
  Layer = "",
  Link = "🔗",
  LeftArrow = "",
  LeftArrowCircled = "",
  LightUpAndRight = "└╴",
  LightVerticalAndRight = "├╴",
  Lock = "",
  Magnify = " ",
  Orbit = "󰀘 ",
  Pencil = " ",
  Prompt = "❯",
  RightArrow = "→",
  RightArrowCircled = "",
  ScriptSmall = "ℓ",
  SquarDot = "▪",
  Square = "■",
  Table = "",
  Tag = "",
  User = "",
  VerticalBar = "▎",
  VerticalBarBold = "▊",
  VerticalBarSemi = "▍",
  VerticalBarSplit = "┊",
  VerticalBarThin = "│",
  VerticalBarVeryThin = "▕",
  Watch = "",
}

M.status = {
  Error = "",
  Hint = "󰌶",
  Info = "󰋽",
  Warn = "󰳤",
}

M.type = {
  Array = "",
  Boolean = "󰨙",
  Null = "",
  Number = "󰎠",
  Object = "",
  String = "",
}

return M
