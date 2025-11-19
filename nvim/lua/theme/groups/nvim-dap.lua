local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  -- stylua: ignore
  return {
    DapBreakpointActiveLine = { bg = ds.color.blend(c.yellow2, c.bg3, 0.14) },

    DapUINormal             = { fg = ds.color.get("Normal") },
    DapUIFloatNormal        = { bg = c.bg0 },
    DapUIFloatBorder        = { fg = c.gray2 },

    DapUIBreakpointsPath    = { link = "@module.builtin" },
    DapUICurrentFrameName   = { link = "@class" },
    DapUIDecoration         = { link = "DAPUINormal" },
    DapUIFrameName          = { link = "DAPUINormal" },
    DapUILineNumber         = { link = "@keyword.debug" },
    DapUIModifiedValue      = { link = "@keyword.debug" },
    DapUIScope              = { link = "@module.builtin" },
    DapUISource             = { link = "@conceal" },
    DapUIStoppedThread      = { link = "@module.builtin" },
    DapUIType               = { link = "@type" },
    DapUIValue              = { link = "@keyword.debug" },
    DapUIVariable           = { link  = "@variable" },
    DapUIWatchesEmpty       = { fg = c.red1 },

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
