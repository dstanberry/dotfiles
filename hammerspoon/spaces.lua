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

local MOD = { "cmd" }
local ALT_MOD = { "cmd", "ctrl", "alt" }

local SWITCHER_CACHE = {}

local GRID = {
  bottomHalf = "0,6 12x6",
  bottomLeft = "0,6 6x6",
  bottomRight = "6,6 6x6",
  fullScreen = "0,0 12x12",
  leftHalf = "0,0 6x12",
  leftThird = "0,0 4x12",
  leftTwoThirds = "0,0 8x12",
  rightHalf = "6,0 6x12",
  rightThird = "8,0 4x12",
  rightTwoThirds = "4,0 8x12",
  topHalf = "0,0 12x6",
  topLeft = "0,0 6x6",
  topRight = "6,0 6x6",
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

local function chain(movements)
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

local function getSwitcher(screenId, limitToSpace)
  local key = screenId .. "_" .. tostring(limitToSpace)

  if not SWITCHER_CACHE[key] then
    SWITCHER_CACHE[key] = hs.window.switcher.new(
      hs.window.filter.new({}):setCurrentSpace(limitToSpace):setScreens(screenId):setDefaultFilter {
        rejectTitles = { "Microsoft Teams Notification", "Window" },
        visible = true,
      }
    )
  end
  return SWITCHER_CACHE[key]
end

local function moveFocus(direction)
  local currentWin = hs.window.focusedWindow()
  if not currentWin then return end

  local screenId = currentWin:screen():id()
  local wf = getSwitcher(screenId, true).wf
  local allWindows = wf:getWindows()
  local validWindows = {}
  local currentIndex, targetIndex

  for _, win in ipairs(allWindows) do
    local frame = win:frame()
    if win:title() ~= "" and frame.w > 0 and frame.h > 0 then table.insert(validWindows, win) end
  end

  table.sort(validWindows, function(a, b) return a:frame().x < b:frame().x end)

  for i, win in ipairs(validWindows) do
    if win:id() == currentWin:id() then
      currentIndex = i
      break
    end
  end

  if not currentIndex then return end

  if direction == "west" then
    targetIndex = currentIndex - 1
    if targetIndex < 1 then targetIndex = #validWindows end
  else
    targetIndex = currentIndex + 1
    if targetIndex > #validWindows then targetIndex = 1 end
  end
  validWindows[targetIndex]:focus()
end

local function moveFocusToScreen(direction)
  local currentWin = hs.window.focusedWindow()
  local currentScreen = currentWin and currentWin:screen() or hs.screen.mainScreen()
  local targetScreen = (direction == "west") and currentScreen:toWest() or currentScreen:toEast()

  if targetScreen then
    local wf = getSwitcher(targetScreen:id(), true).wf
    local screenWindows = wf:getWindows(hs.window.filter.sortByFocusedLast)

    if #screenWindows > 0 then
      screenWindows[1]:focus()
    else
      local center = hs.geometry.rectMidPoint(targetScreen.fullFrame())
      hs.mouse.absolutePosition(center)
    end
  end
end

local function moveToSpace(keys, direction)
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

hs.hotkey.bind(MOD, "=", chain { GRID.fullScreen })
hs.hotkey.bind(MOD, "down", chain { GRID.bottomHalf, GRID.bottomLeft, GRID.bottomRight })
hs.hotkey.bind(MOD, "up", chain { GRID.topHalf, GRID.topLeft, GRID.topRight })
hs.hotkey.bind(MOD, "left", chain { GRID.leftTwoThirds, GRID.leftHalf, GRID.leftThird, GRID.topLeft, GRID.bottomLeft })
-- stylua: ignore
hs.hotkey.bind(MOD, "right", chain { GRID.rightTwoThirds, GRID.rightHalf, GRID.rightThird, GRID.topRight, GRID.bottomRight })

hs.hotkey.bind(ALT_MOD, "left", function() hs.window.frontmostWindow():moveOneScreenWest(nil, true) end)
hs.hotkey.bind(ALT_MOD, "right", function() hs.window.frontmostWindow():moveOneScreenEast(nil, true) end)

hs.hotkey.bind(ALT_MOD, "a", function() moveFocusToScreen "west" end)
hs.hotkey.bind(ALT_MOD, "g", function() moveFocusToScreen "east" end)

hs.hotkey.bind(ALT_MOD, "c", function() moveToSpace(ALT_MOD, "previous") end)
hs.hotkey.bind(ALT_MOD, "v", function() moveToSpace(ALT_MOD, "next") end)

hs.hotkey.bind(ALT_MOD, "d", function() moveFocus "west" end)
hs.hotkey.bind(ALT_MOD, "f", function() moveFocus "east" end)
