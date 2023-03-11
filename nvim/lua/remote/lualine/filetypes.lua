local disable_in_statusline = {
  "dbui",
  "DiffviewFiles",
  "gitcommit",
  "help",
  "lazy",
  "neo-tree",
  "NeogitPopup",
  "NeogitStatus",
  "qf",
  "TelescopePrompt",
  "toggleterm",
}

local disable_in_winbar = {
  -- "DiffviewFilePanel",
  -- "DiffviewFiles",
  "gitcommit",
  "help",
  "lazy",
  "neo-tree",
  "NeogitCommitMessage",
  "NeogitPopup",
  "NeogitStatus",
  "qf",
  "TelescopePrompt",
  "toggleterm",
}

local empty_in_winbar = {
  "dbui",
  "DiffviewFilePanel",
  "DiffviewFiles",
  "neo-tree",
}

return {
  stl_disabled = disable_in_statusline,
  wb_disabled = disable_in_winbar,
  wb_suppressed = empty_in_winbar
}
