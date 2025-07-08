local sketchybar_path = "/opt/homebrew/bin/sketchybar"
local target_app = "Ghostty"

local function set_hidden(state)
  hs.task.new(sketchybar_path, nil, { "--bar", "hidden=" .. state }):start()
end

local wf = hs.window.filter.new()
wf:subscribe(hs.window.filter.windowFocused, function(win, app_name)
  local flags = ev:getFlags()

  if app_name == target_app and not flags.alt then
    set_hidden("on")
  else
    set_hidden("off")
  end
end)

option_watcher = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(ev)
  local flags = ev:getFlags()
  local app_name = hs.application.frontmostApplication():name()

  if flags.alt then
    set_hidden("off")
  elseif app_name == target_app then
    set_hidden("on")
  end
end)

option_watcher:start()
