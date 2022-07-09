-- verify nvim-surround is available
local ok, surround = pcall(require, "nvim-surround")
if not ok then
  return
end

local utils = require "nvim-surround.utils"

surround.setup {
  keymaps = {
    insert = "ys",
    insert_line = "yss",
    visual = "S",
    delete = "ds",
    change = "cs",
  },
  delimiters = {
    pairs = {
      ["("] = { "( ", " )" },
      [")"] = { "(", ")" },
      ["{"] = { "{ ", " }" },
      ["}"] = { "{", "}" },
      ["<"] = { "< ", " >" },
      [">"] = { "<", ">" },
      ["["] = { "[ ", " ]" },
      ["]"] = { "[", "]" },
      ["t"] = function()
        return {
          utils.get_input "Enter the left delimiter/tag: ",
          utils.get_input "Enter the right delimiter/tag: ",
        }
      end,
      ["f"] = function()
        return {
          utils.get_input "Enter the function name: " .. "(",
          ")",
        }
      end,
    },
    separators = {
      ["'"] = { "'", "'" },
      ['"'] = { '"', '"' },
      ["`"] = { "`", "`" },
    },
    HTML = {
      ["t"] = true,
    },
    aliases = {
      ["a"] = ">",
      ["p"] = ")",
      ["c"] = "}",
      ["s"] = "]",
      -- change/delete any quote character
      ["q"] = { '"', "'", "`" },
      -- change/delete any of the following delimiters
      ["d"] = { ")", "]", "}", ">", "'", '"', "`" },
    },
  },
  highlight_motion = {
    duration = 0,
  },
}
