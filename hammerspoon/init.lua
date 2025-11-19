require "spaces"

hs.application.enableSpotlightForNameSearches(true)

--  Toggle new/existing processes
local chord = { "ctrl", "alt" }
local shortcuts = {
  ["Ghostty"] = { "1", { "File", "New Window" } },
  ["Code"] = { "2", { "File", "New Window" } },
  ["Google Chrome"] = { "3", { "File", "New Window" } },
  ["Microsoft Teams"] = { "4" },
  ["Microsoft Outlook"] = { "5", { "File", "New", "Main Window" } },
}

local function showOrHide(appName)
  local app = hs.application.get(appName)
  if app then
    if not app:mainWindow() then
      app:selectMenuItem(shortcuts[appName][2])
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
    if appName == "Code" then
      local alt_name = "Visual Studio Code"
      hs.application.launchOrFocus(alt_name)
      hs.application.get(alt_name)
    end
    hs.application.launchOrFocus(appName)
    hs.application.get(appName)
  end
end

for appName, shortcut in pairs(shortcuts) do
  hs.hotkey.new(chord, shortcut[1], function() showOrHide(appName) end):enable()
end

hs.loadSpoon "ReloadConfiguration"
spoon.ReloadConfiguration:start()
