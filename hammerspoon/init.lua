require "spaces"

hs.application.enableSpotlightForNameSearches(true)

--  Toggle new/existing processes
local chord = { "ctrl", "alt" }
local shortcuts = {
  ["kitty"] = "1",
  ["Google Chrome"] = "2",
  ["Visual Studio Code"] = "3",
  ["Microsoft Teams"] = "4",
  ["Microsoft Outlook"] = "5",
}
local new = {
  ["kitty"] = { "Shell", "New OS Window" },
  ["Google Chrome"] = { "File", "New Window" },
  ["Visual Studio Code"] = { "File", "New Window" },
  ["Microsoft Teams"] = nil,
  ["Microsoft Outlook"] = { "File", "New", "Main Window" },
}

local showOrHide = function(appName)
  local app = hs.application.get(appName)
  if app then
    if not app:mainWindow() then
      app:selectMenuItem(new[appName])
    elseif app:isFrontmost() then
      app:hide()
    else
      app:activate()
    end
  else
    hs.application.launchOrFocus(appName)
    hs.application.get(appName)
  end
end

for appName, shortcut in pairs(shortcuts) do
  hs.hotkey.new(chord, shortcut, function() showOrHide(appName) end):enable()
end

hs.loadSpoon "ReloadConfiguration"
spoon.ReloadConfiguration:start()
