return {
  "monaqa/dial.nvim",
  keys = {
    { "<c-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "dial: increment" },
    { "<c-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "dial: decrement" },
  },
  config = function()
    local augend = require "dial.augend"
    local config = require "dial.config"

    local ordinal_numbers = augend.constant.new {
      elements = {
        "first",
        "second",
        "third",
        "fourth",
        "fifth",
        "sixth",
        "seventh",
        "eighth",
        "ninth",
        "tenth",
      },
      word = false,
      cyclic = true,
    }

    local weekdays = augend.constant.new {
      elements = {
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
      },
      word = true,
      cyclic = true,
    }

    local months = augend.constant.new {
      elements = {
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      },
      word = true,
      cyclic = true,
    }

    config.augends:register_group {
      default = {
        augend.constant.alias.bool,
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.semver.alias.semver,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.new {
          elements = {
            "True",
            "False",
          },
          word = true,
          cyclic = true,
        },
        augend.constant.new {
          elements = { "and", "or" },
          word = true,
          cyclic = true,
        },
        augend.constant.new {
          elements = { "&&", "||" },
          word = false,
          cyclic = true,
        },
        ordinal_numbers,
        weekdays,
        months,
      },
      markdown = {
        augend.misc.alias.markdown_header,
        augend.constant.alias.bool,
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.semver.alias.semver,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.new {
          elements = {
            "True",
            "False",
          },
          word = true,
          cyclic = true,
        },
        augend.constant.new {
          elements = { "and", "or" },
          word = true,
          cyclic = true,
        },
        augend.constant.new {
          elements = { "&&", "||" },
          word = false,
          cyclic = true,
        },
        ordinal_numbers,
        weekdays,
        months,
      },
    }
  end,
}
