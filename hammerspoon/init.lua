local sketchybar_path = "/opt/homebrew/bin/sketchybar"

local function set_hidden(state)
  hs.task.new(sketchybar_path, nil, { "--bar", "hidden=" .. state }):start()
end

option_watcher = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(ev)
  local flags = ev:getFlags()

  if flags.alt then
    set_hidden("off")
  else
    set_hidden("on")
  end
end)

option_watcher:start()
