local disable_in_statusline = {
  "DiffviewFiles",
  "gitcommit",
  "help",
  "lazy",
  "lir",
  "NeogitPopup",
  "NeogitStatus",
  "qf",
  "TelescopePrompt",
  "toggleterm",
}

local disable_in_winbar = {
  "DiffviewFilePanel",
  "DiffviewFiles",
  "gitcommit",
  "help",
  "lazy",
  "lir",
  "NeogitCommitMessage",
  "NeogitPopup",
  "NeogitStatus",
  "qf",
  "TelescopePrompt",
  "toggleterm",
}

return {
  stl_disabled = disable_in_statusline,
  wb_disabled = disable_in_winbar,
}
