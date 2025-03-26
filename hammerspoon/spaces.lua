--[[
https://github.com/asmagill/hs._asm.spaces

$ tar -xzf ~/Downloads/spaces-v0.x.tar.gz
$ cd hs._asm.spaces
$ HS_APPLICATION=/Applications PREFIX=~/.config/hammerspoon make install
]]

local spaces = require "hs.spaces"

spaces.setDefaultMCwaitTime(0.5)

hs.grid.setGrid "12x12"
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.window.animationDuration = 0

hs.window.switcher.ui.textColor = { 0, 0, 0 }
hs.window.switcher.ui.textSize = 10
hs.window.switcher.ui.highlightColor = { 0.18, 0.204, 0.251, 0.8 }
hs.window.switcher.ui.backgroundColor = { 0.2, 0.2, 0.2, 0.3 }
hs.window.switcher.ui.thumbnailSize = 160
hs.window.switcher.ui.showThumbnails = true
hs.window.switcher.ui.showSelectedThumbnail = false
hs.window.switcher.ui.titleBackgroundColor = { 0, 0, 0, 0 }
hs.window.switcher.ui.showTitles = false

-- include minimized/hidden windows, current Space & screen only
local switchers = setmetatable({}, {
  __index = function(t, key)
    local switcher =
      hs.window.switcher.new(hs.window.filter.new({}):setCurrentSpace(true):setScreens(key):setDefaultFilter {
        rejectTitles = {
          "Microsoft Teams Notification",
        },
      })
    rawset(t, key, switcher)
    return switcher
  end,
})

local PREFIX_ACTION = { "cmd" }
-- local CTRL_PREFIX_ACTION = { "cmd", "ctrl" }
local HYPER_PREFIX_ACTION = { "ctrl", "cmd", "alt" }

local GRID = {
  topHalf = "0,0 12x6",
  rightTwoThirds = "4,0 8x12",
  rightThird = "8,0 4x12",
  rightHalf = "6,0 6x12",
  bottomHalf = "0,6 12x6",
  leftTwoThirds = "0,0 8x12",
  leftThird = "0,0 4x12",
  leftHalf = "0,0 6x12",
  topLeft = "0,0 6x6",
  topRight = "6,0 6x6",
  bottomRight = "6,6 6x6",
  bottomLeft = "0,6 6x6",
  fullScreen = "0,0 12x12",
}

local chain = function(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()
    local screen = win:screen()

    if LastSeenChain ~= movements or LastSeenAt < now - chainResetInterval or LastSeenWindow ~= id then
      sequenceNumber = 1
      LastSeenChain = movements
    elseif sequenceNumber == 1 then
      -- At end of chain, restart chain on next screen.
      screen = screen:next()
    end

    LastSeenAt = now
    LastSeenWindow = id

    hs.grid.MARGINX = cycleLength == 1 and 0 or 5
    hs.grid.MARGINY = cycleLength == 1 and 0 or 5
    hs.grid.set(win, movements[sequenceNumber], screen)
    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end

local getSpaceId = function(spaceNumber)
  local spaceNames = hs.spaces.missionControlSpaceNames()
  local spaceName = "Desktop " .. spaceNumber
  for _, desktop in pairs(spaceNames) do
    for i, name in pairs(desktop) do
      if spaceNumber == name:sub(-1) or name:lower():match(spaceName:lower()) then return i end
    end
  end
  return nil
end

local moveToSpace = function(spaceNumber)
  local spaceName = "Desktop " .. spaceNumber
  local spaceId = getSpaceId(spaceNumber)
  if spaceId then
    local focusedWindow = hs.window.focusedWindow()
    if focusedWindow then
      hs.spaces.moveWindowToSpace(focusedWindow:id(), spaceId)
    else
      hs.alert.show "No focused window"
    end
  else
    hs.alert.show("Space not found: " .. spaceName)
  end
end

hs.hotkey.bind(PREFIX_ACTION, "=", chain { GRID.fullScreen })
hs.hotkey.bind(PREFIX_ACTION, "up", chain { GRID.topHalf, GRID.topLeft, GRID.topRight })
hs.hotkey.bind(PREFIX_ACTION, "down", chain { GRID.bottomHalf, GRID.bottomLeft, GRID.bottomRight })
hs.hotkey.bind(
  PREFIX_ACTION,
  "right",
  chain { GRID.rightHalf, GRID.topRight, GRID.bottomRight, GRID.rightTwoThirds, GRID.rightThird }
)
hs.hotkey.bind(
  PREFIX_ACTION,
  "left",
  chain { GRID.leftHalf, GRID.topLeft, GRID.bottomLeft, GRID.leftTwoThirds, GRID.leftThird }
)

-- NOTE: Stop at 7 because Ctrl-Option-Cmd-8 inverts colors
hs.hotkey.bind(HYPER_PREFIX_ACTION, "1", function() moveToSpace(1) end)
hs.hotkey.bind(HYPER_PREFIX_ACTION, "2", function() moveToSpace(2) end)

hs.hotkey.bind(HYPER_PREFIX_ACTION, "left", function() hs.window.frontmostWindow():moveOneScreenWest(nil, true) end)
hs.hotkey.bind(HYPER_PREFIX_ACTION, "right", function() hs.window.frontmostWindow():moveOneScreenEast(nil, true) end)

hs.hotkey.bind(HYPER_PREFIX_ACTION, "d", function()
  local switcher = switchers[hs.window.focusedWindow():screen():id()]
  switcher:previous()
end)
hs.hotkey.bind(HYPER_PREFIX_ACTION, "f", function()
  local switcher = switchers[hs.window.focusedWindow():screen():id()]
  switcher:next()
end)
