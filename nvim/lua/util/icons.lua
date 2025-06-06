---@class util.icons
local M = {}
M.border = {
  CompactRound = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  CompactSquare = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
  Default = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
}

M.table = {
  Alignment = { "╼", "╾", "╴", "╶" },
  Divider = { "┬", "├", "┤", "┼", "┴" },
}

M.diagnostics = {
  Error = "",
  Warn = "",
  Hint = "",
  Info = "",
}

M.debug = {
  Breakpoint = "",
  BreakpointActive = "",
  BreakpointConditional = "",
  BreakpointLog = "󰗽",
  BreakpointRejected = "",
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
  FolderClosed = "󰉋",
  FolderEmpty = "󱞞",
  FolderOpened = "󰝰",
  FolderOutlineClosed = "",
  FolderOutlineOpened = "",
  Project = "",
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
  Copilot = "",
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
  Checked = "󰄲",
  Unchecked = "󰄱",
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
  Block = "█",
  BrailleBlank = "⠀", -- U+2800
  Calendar = "",
  CaretRight = "",
  CheckFilled = "",
  ChevronRight = "›",
  Circle = "",
  CircleDot = "•",
  Clipboard = "󰅍",
  Close = "",
  CloseBold = "",
  Data = "",
  DiagonalExpand = "",
  DiagonalShrink = "󰘕",
  Diamond = "",
  DownArrow = "↓",
  Ellipses = "⋯",
  Event = "⚡",
  Exit = "",
  Extensions = "",
  FilledCircle = "●",
  FilledCircleLarge = "⬤",
  FoldClosed = "",
  FoldOpened = "",
  Gear = "",
  HalfBlockLower = "▃",
  HalfBlockUpper = "▀",
  Image = "󰥶",
  Key = "",
  Language = "",
  Layer = "",
  LeftArrow = "",
  LeftArrowCircled = "",
  LightUpAndRight = "└╴",
  LightVerticalAndRight = "├╴",
  Link = "󰌷",
  Lock = "",
  Magnify = "",
  Orbit = "󰀘",
  Pc = "",
  Pencil = "",
  Prompt = "❯",
  Revolve = "",
  RightArrow = "→",
  RightArrowCircled = "",
  ScriptSmall = "ℓ",
  Sleep = "󰒲",
  Square = "■",
  SquareDot = "▪",
  Table = "",
  Tag = "",
  User = "",
  VerticalBar = "▎",
  VerticalBarBold = "▊",
  VerticalBarMiddle = "│",
  VerticalBarMiddleDashed = "┊",
  VerticalBarRight = "▕",
  VerticalBarSemi = "▍",
  VerticalBarThin = "▏",
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
