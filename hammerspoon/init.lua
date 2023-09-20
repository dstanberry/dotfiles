---@diagnostic disable: undefined-global

--  Toggle new/existing processes
local chord = { "ctrl", "alt" }
local shortcuts = {
	["net.kovidgoyal.kitty"] = "1",
	["com.google.Chrome"] = "2",
	["com.microsoft.VSCode"] = "3",
	["com.microsoft.teams"] = "4",
	["com.microsoft.Outlook"] = "5",
}
local new = {
	["net.kovidgoyal.kitty"] = { "kitty", "New OS Window" },
	["com.google.Chrome"] = { "File", "New Window" },
	["com.microsoft.VSCode"] = { "File", "New Window" },
	["com.microsoft.teams"] = nil,
	["com.microsoft.Outlook"] = { "File", "New", "Main Window" },
}

local function showOrHide(appName)
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
	hs.hotkey
		.new(chord, shortcut, function()
			showOrHide(appName)
		end)
		:enable()
end

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
