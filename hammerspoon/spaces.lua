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

local PREFIX_ACTION = { "cmd" }
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

local SPACE_MOVEMENT_CONFIG = {
  mouseOffset = { x = 5, y = 12 },
  delays = { switch = 0.2, release = 0.5 },
  inProgress = false,
}

local SPACE_DIRECTIONS = setmetatable({
  previous = {
    key = "e",
    edgeMessage = "Currently at left-most space.",
    edgeCheck = function(current, available) return current == available[1] end,
  },
  next = {
    key = "r",
    edgeMessage = "Currently at right-most space.",
    edgeCheck = function(current, available) return current == available[#available] end,
  },
}, { __index = function() error "Invalid space direction" end })

-- include minimized/hidden windows, current Space & screen only
local SWITCHERS = setmetatable({}, {
  __index = function(t, key)
    local switcher =
      hs.window.switcher.new(hs.window.filter.new({}):setCurrentSpace(true):setScreens(key):setDefaultFilter {
        rejectTitles = {
          "Microsoft Teams Notification",
          "Window",
        },
      })
    rawset(t, key, switcher)
    return switcher
  end,
})

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

local moveToSpace = function(keys, direction)
  if SPACE_MOVEMENT_CONFIG.inProgress then return end
  SPACE_MOVEMENT_CONFIG.inProgress = true

  local directionConfig = SPACE_DIRECTIONS[direction]
  local win = hs.window.focusedWindow()
  local availableSpaces = hs.spaces.spacesForScreen()
  local currentSpace = hs.spaces.focusedSpace()

  if directionConfig.edgeCheck(currentSpace, availableSpaces) then
    hs.alert.show(directionConfig.edgeMessage)
    SPACE_MOVEMENT_CONFIG.inProgress = false
    return
  end

  if not win then
    SPACE_MOVEMENT_CONFIG.inProgress = false
    return
  end

  win:unminimize()
  win:raise()

  local frame = win:frame()
  local clickPos =
    hs.geometry.point(frame.x + SPACE_MOVEMENT_CONFIG.mouseOffset.x, frame.y + SPACE_MOVEMENT_CONFIG.mouseOffset.y)
  local centerPos = hs.geometry.point(frame.x + frame.w / 2, frame.y + frame.h / 2)

  hs.mouse.absolutePosition(clickPos)
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, clickPos):post()
  hs.timer.doAfter(SPACE_MOVEMENT_CONFIG.delays.switch, function()
    hs.eventtap.event.newKeyEvent(keys, directionConfig.key, true):post()
    hs.timer.doAfter(0.1, function() hs.eventtap.event.newKeyEvent(keys, directionConfig.key, false):post() end)
  end)
  hs.timer.doAfter(SPACE_MOVEMENT_CONFIG.delays.release, function()
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, clickPos):post()
    hs.mouse.absolutePosition(centerPos)
    win:raise()
    win:focus()
    SPACE_MOVEMENT_CONFIG.inProgress = false
  end)
end

hs.hotkey.bind(PREFIX_ACTION, "=", chain { GRID.fullScreen })
hs.hotkey.bind(PREFIX_ACTION, "down", chain { GRID.bottomHalf, GRID.bottomLeft, GRID.bottomRight })
hs.hotkey.bind(PREFIX_ACTION, "up", chain { GRID.topHalf, GRID.topLeft, GRID.topRight })
-- stylua: ignore
hs.hotkey.bind(PREFIX_ACTION, "left", chain { GRID.leftHalf, GRID.topLeft, GRID.bottomLeft, GRID.leftTwoThirds, GRID.leftThird })
-- stylua: ignore
hs.hotkey.bind(PREFIX_ACTION, "right", chain { GRID.rightHalf, GRID.topRight, GRID.bottomRight, GRID.rightTwoThirds, GRID.rightThird })

hs.hotkey.bind(HYPER_PREFIX_ACTION, "left", function() hs.window.frontmostWindow():moveOneScreenWest(nil, true) end)
hs.hotkey.bind(HYPER_PREFIX_ACTION, "right", function() hs.window.frontmostWindow():moveOneScreenEast(nil, true) end)

hs.hotkey.bind(HYPER_PREFIX_ACTION, "d", function() SWITCHERS[hs.window.focusedWindow():screen():id()]:previous() end)
hs.hotkey.bind(HYPER_PREFIX_ACTION, "f", function() SWITCHERS[hs.window.focusedWindow():screen():id()]:next() end)

hs.hotkey.bind(HYPER_PREFIX_ACTION, "c", function() moveToSpace(HYPER_PREFIX_ACTION, "previous") end)
hs.hotkey.bind(HYPER_PREFIX_ACTION, "v", function() moveToSpace(HYPER_PREFIX_ACTION, "next") end)
