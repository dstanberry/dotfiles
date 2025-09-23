---@class util.icons
local M = {}

---Box drawing characters for window borders.
M.border = {
  CompactRound = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  CompactSquare = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
  Default = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
}

---Box drawing characters for tables.
M.table = {
  Alignment = { "╼", "╾", "╴", "╶" },
  Divider = { "┬", "├", "┤", "┼", "┴" },
}

---Diagnostic icons for Neovim's LSP, similar to `util.icons.status`
M.diagnostics = {
  Error = "",
  Warn = "",
  Hint = "",
  Info = "",
}

---Debugging related icons.
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
M.documents = {
  File = "",
  Files = "",
  FolderClosed = "󰉋",
  FolderEmpty = "󱞞",
  FolderOpened = "󰝰",
  FolderOutlineClosed = "",
  FolderOutlineOpened = "",
  Project = "",
  SymbolicLink = "",
}

---Git related icons.
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
M.markdown = {
  Checked = "󰄲",
  H1 = "",
  H2 = "",
  H3 = "",
  H4 = "",
  H5 = "",
  H6 = "",
  ListMinus = "•",
  Unchecked = "󰄱",
}

---Miscellaneous icons for various purposes.
M.misc = {
  ArrowSwap = " ",
  Block = "█",
  BrailleBlank = "⠀", -- U+2800
  Brain = "󰧑",
  Calendar = "",
  CaretRight = "",
  Check = "✅",
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
  EigthBlockLower = "▁",
  EigthBlockUpper = "▔",
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
  Image = "",
  Key = "",
  Language = "",
  Layer = "",
  LeftArrow = "",
  LeftArrowCircled = "",
  LightUpAndRight = "└╴",
  LightVerticalAndRight = "├╴",
  Link = "󰌹",
  Lock = "",
  Magnify = "",
  Orbit = "󰀘",
  Package = "",
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
  Tools = "",
  User = "",
  VerticalBar = "▎",
  VerticalBarBold = "▊",
  VerticalBarMiddle = "│",
  VerticalBarMiddleDashed = "┊",
  VerticalBarRight = "▕",
  VerticalBarSemi = "▍",
  VerticalBarThin = "▏",
  Watch = "",
  Wrench = "󰯠",
}

M.spinners = {
  Default = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
}

---Status icons for Neovim's LSP, similar to `util.icons.diagnostics`
M.status = {
  Error = "",
  Hint = "󰌶",
  Info = "󰋽",
  Warn = "󰳤",
}

---Icons representing scalar and two-dimensional data types.
M.type = {
  Array = "",
  Boolean = "󰨙",
  Null = "",
  Number = "󰎠",
  Object = "",
  String = "",
}

return M
