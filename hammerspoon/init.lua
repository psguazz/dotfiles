local sketchybar_path = "/usr/local/bin/sketchybar"

local function set_bar(state)
  hs.task.new(sketchybar_path, nil, { "--bar", "topmost=" .. state }):start()
end

option_watcher = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(ev)
  local flags = ev:getFlags()

  if flags.alt then
    set_bar("on")
  else
    set_bar("off")
  end
end)

option_watcher:start()
