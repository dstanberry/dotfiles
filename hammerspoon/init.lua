require "spaces"

hs.application.enableSpotlightForNameSearches(true)

--  Toggle new/existing processes
local chord = { "ctrl", "alt" }
local shortcuts = {
  ["kitty"] = "1",
  ["Google Chrome"] = "2",
  ["Code"] = "3",
  ["Microsoft Teams"] = "4",
  ["Microsoft Outlook"] = "5",
}
local new = {
  ["kitty"] = { "Shell", "New OS Window" },
  ["Google Chrome"] = { "File", "New Window" },
  ["Code"] = { "File", "New Window" },
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
      if appName == "Microsoft Teams" then
        local menu_items = app:getMenuItems()[4] --4th menu item
        local title = menu_items["AXTitle"]
        if title == "Window" then
          local menu_options = menu_items["AXChildren"][1]
          local target = menu_options[#menu_options]["AXTitle"]
          if target and string.match(target, "Microsoft Teams Classic") then app:selectMenuItem { title, target } end
        end
      end
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
