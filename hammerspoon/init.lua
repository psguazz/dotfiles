local sketchybar_path = "/usr/local/bin/sketchybar"

local hide_delay = 0.7
local hide_timer = nil

local function set_bar(state)
  hs.task.new(sketchybar_path, nil, { "--bar", "topmost=" .. state }):start()
end

local function show_bar()
  if hide_timer then
    hide_timer:stop()
    hide_timer = nil
  else
    set_bar("on")
  end
end

local function hide_bar()
  if not hide_timer then
    hide_timer = hs.timer.doAfter(hide_delay, function()
      set_bar("off")
      hide_timer = nil
    end)
  end
end

local option_watcher = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(ev)
  local flags = ev:getFlags()

  if flags.alt then
    show_bar()
  else
    hide_bar()
  end
end)

option_watcher:start()
