---@class util.icons
local M = {}

---@alias util.icons.glyph string

---Box drawing characters for window borders.
---@type table<string, util.icons.glyph[]>
M.border = {
  CompactRound = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  CompactSquare = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
  Default = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
}

---Box drawing characters for tables.
---@type table<string, util.icons.glyph[]>
M.table = {
  Alignment = { "╼", "╾", "╴", "╶" },
  Divider = { "┬", "├", "┤", "┼", "┴" },
}

---Diagnostic icons for Neovim's LSP, similar to `util.icons.status`
---@type table<string, util.icons.glyph>
M.diagnostics = {
  Error = "",
  Warn = "",
  Hint = "",
  Info = "",
}

---Debugging related icons.
---@type table<string, util.icons.glyph>
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

---Document/File related icons.
---@type table<string, util.icons.glyph>
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

---Git related icons.
---@type table<string, util.icons.glyph>
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

---Icons used to convey groupings or categories.
---@type table<string, util.icons.glyph>
M.groups = {
  Book = "",
  Diff = "",
  Lab = "",
  Pinned = "",
  Sql = "",
  StackFrame = "",
  Tree = "󰙅",
}

---Icons representing various programming constructs and elements.
---@type table<string, util.icons.glyph>
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

---Markdown related icons.
---@type table<string, util.icons.glyph>
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

---Miscellaneous icons for various purposes.
---@type table<string, util.icons.glyph>
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

---Status icons for Neovim's LSP, similar to `util.icons.diagnostics`
---@type table<string, util.icons.glyph>
M.status = {
  Error = "",
  Hint = "󰌶",
  Info = "󰋽",
  Warn = "󰳤",
}

---Icons representing scalar and two-dimensional data types.
---@type table<string, util.icons.glyph>
M.type = {
  Array = "",
  Boolean = "󰨙",
  Null = "",
  Number = "󰎠",
  Object = "",
  String = "",
}

return M
