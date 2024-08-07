local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  -- stylua: ignore
  return {
    DapBreakpointActiveLine = { bg = ds.color.blend(c.yellow2, c.bg3, 0.14) },

    DapUINormal             = { fg = ds.color.get_color("Normal") },
    DapUIFloatNormal        = { bg = c.bg0 },
    DapUIFloatBorder        = { fg = c.gray2 },

    DapUIVariable           = { link  = "@variable" },
    DapUIValue              = { link = "@keyword.debug" },
    DapUIType               = { link = "@type" },

    DapUIStop               = { fg = c.red1 },
    DapUIStopNC             = { link = "DapUIStop" },
    DapUIRestart            = { fg = c.green1 },
    DapUIRestartNC          = { link = "DapUIRestart" },
    DapUIStepOver           = { fg = c.blue0 },
    DapUIStepOverNC         = { link = "DapUIStepOver" },
    DapUIStepInto           = { fg = c.blue0 },
    DapUIStepIntoNC         = { link = "DapUIStepInto" },
    DapUIStepOut            = { fg = c.blue0 },
    DapUIStepOutNC          = { link = "DapUIStepOut" },
    DapUIStepBack           = { fg = c.blue0 },
    DapUIStepBackNC         = { link = "DapUIStepBack" },
    DapUIPlayPause          = { fg = c.blue4 },
    DapUIPlayPauseNC        = { link = "DapUIPlayPause" },
    DapUIUnavailable        = { fg = c.gray2 },
    DapUIUnavailableNC      = { link = "DapUIUnavailable" },
    DapUIThread             = { fg = c.green0 },
    DapUIThreadNC           = { link = "DapUIThread" }
  }
end

return M
