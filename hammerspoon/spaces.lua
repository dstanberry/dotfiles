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

    hs.grid.set(win, movements[sequenceNumber], screen)
    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end

local moveToSpace = function(space)
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local spaceID = hs.spaces.spacesForScreen(screen)[space]
  spaces.moveWindowToSpace(win:id(), spaceID)
  hs.alert.show(win:title() .. " moved to Desktop " .. space)
end

local getPrevSpace = function(screen)
  local activeSpace = spaces.activeSpaceOnScreen(screen)
  local availableSpaces = hs.spaces.spacesForScreen(screen)
  local prevSpace
  for i, s in ipairs(availableSpaces) do
    if s == activeSpace then prevSpace = i - 1 end
  end
  if prevSpace < 1 then prevSpace = #availableSpaces end
  return prevSpace
end

local getNextSpace = function(screen)
  local activeSpace = spaces.activeSpaceOnScreen(screen)
  local availableSpaces = hs.spaces.spacesForScreen(screen)
  local nextSpace
  for i, s in ipairs(availableSpaces) do
    if s == activeSpace then nextSpace = i + 1 end
  end
  if nextSpace > #availableSpaces then nextSpace = 1 end
  return nextSpace
end

local moveOneSpaceWest = function()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local prevSpace = getPrevSpace(screen)
  local spaceID = hs.spaces.spacesForScreen(screen)[prevSpace]
  spaces.moveWindowToSpace(win:id(), spaceID)
  hs.alert.show(win:title() .. " moved to Desktop " .. prevSpace)
end

local moveOneSpaceEast = function()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local nextSpace = getNextSpace(screen)
  local spaceID = hs.spaces.spacesForScreen(screen)[nextSpace]
  spaces.moveWindowToSpace(win:id(), spaceID)
  hs.alert.show(win:title() .. " moved to Desktop " .. nextSpace)
end

-- local gotoOneSpaceWest = function()
--   local win = hs.window.focusedWindow()
--   local screen = win:screen()
--   local prevSpace = getPrevSpace(screen)
--   local spaceID = hs.spaces.spacesForScreen(screen)[prevSpace]
--   spaces.gotoSpace(spaceID)
-- end

-- local gotoOneSpaceEast = function()
--   local win = hs.window.focusedWindow()
--   local screen = win:screen()
--   local nextSpace = getNextSpace(screen)
--   local spaceID = hs.spaces.spacesForScreen(screen)[nextSpace]
--   spaces.gotoSpace(spaceID)
-- end

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
hs.hotkey.bind(HYPER_PREFIX_ACTION, "3", function() moveToSpace(3) end)
hs.hotkey.bind(HYPER_PREFIX_ACTION, "4", function() moveToSpace(4) end)
hs.hotkey.bind(HYPER_PREFIX_ACTION, "5", function() moveToSpace(5) end)

hs.hotkey.bind(HYPER_PREFIX_ACTION, "left", function() hs.window.frontmostWindow():moveOneScreenWest(nil, true) end)
hs.hotkey.bind(HYPER_PREFIX_ACTION, "right", function() hs.window.frontmostWindow():moveOneScreenEast(nil, true) end)

-- hs.hotkey.bind(HYPER_PREFIX_ACTION, "e", gotoOneSpaceWest)
-- hs.hotkey.bind(HYPER_PREFIX_ACTION, "r", gotoOneSpaceEast)

hs.hotkey.bind(HYPER_PREFIX_ACTION, "a", moveOneSpaceWest)
hs.hotkey.bind(HYPER_PREFIX_ACTION, "g", moveOneSpaceEast)

hs.hotkey.bind(HYPER_PREFIX_ACTION, "d", function()
  local switcher = switchers[hs.window.focusedWindow():screen():id()]
  switcher:previous()
end)
hs.hotkey.bind(HYPER_PREFIX_ACTION, "f", function()
  local switcher = switchers[hs.window.focusedWindow():screen():id()]
  switcher:next()
end)
